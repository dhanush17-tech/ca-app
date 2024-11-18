import 'dart:async';
import 'dart:io';

import 'package:ca_appoinment/app/const/firebase_const.dart';
import 'package:ca_appoinment/app/const/shared_prefrence.dart';
import 'package:ca_appoinment/features/user/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  AuthBloc({required this.auth, required this.firestore})
      : super(AuthInitial()) {
    on<AuthSignUpEvent>(_authSignUpEvent);
    on<AuthLoginEvent>(_authLoginEvent);
    on<AuthLogOutEvent>(_authLogOutEvent);
    on<AuthChangePasswordEvent>(_authChangePasswordEvent);
    on<AuthForgetPasswordEvent>(_authForgetPasswordEvent);
  }

  FutureOr<void> _authSignUpEvent(
      AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      // Create a account with Email and Password
      await auth
          .createUserWithEmailAndPassword(
              email: event.email, password: event.password)
          .then((value) async {
        String uId = value.user!.uid;
        // Check account already exists or not
        UserModel userModel = UserModel(
          uId: value.user!.uid,
          name: event.name,
          email: event.email,
          accountType: 'user',
          nfToken: event.nfToken,
          accountCreatedDate: DateTime.now().millisecondsSinceEpoch.toString(),
        );
        if (value.additionalUserInfo!.isNewUser) {
// Add Acccount Details into FireStorage
          await firestore
              .collection(FirebaseConst.userCollection)
              .doc(value.user!.uid)
              .set(userModel.toMap());
// Store User Id into Offline Shared preferences
          var pref = await SharedPreferences.getInstance();
          pref.setString(SharedPrefConst.uId, uId);
          pref.setString(SharedPrefConst.userType, SharedPrefConst.user);
        }
        emit(AuthSuccesState(userModel: userModel));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthFailureState(errorMsg: 'password provided is too weak'));
      }
      if (e.code == 'email-already-in-use') {
        emit(AuthFailureState(errorMsg: 'email already exists'));
      }
    } on SocketException catch (e) {
      emit(AuthPassUpdateFailureState(errorMsg: e.message));
    } catch (e) {
      emit(AuthFailureState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> _authLoginEvent(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      await auth
          .signInWithEmailAndPassword(
              email: event.email, password: event.password)
          .then((value) async {
        await firestore
            .collection(FirebaseConst.userCollection)
            .doc(value.user!.uid)
            .update({'nfToken': event.nfToken});
        await firestore
            .collection(FirebaseConst.userCollection)
            .doc(value.user!.uid)
            .get()
            .then((userData) async {
          await getUserData(
              userData: userData, uid: value.user!.uid, emit: emit);
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthFailureState(errorMsg: 'No user found'));
      } else if (e.code == 'wrong-password') {
        emit(AuthFailureState(errorMsg: 'Wrong password'));
      } else {
        emit(AuthFailureState(errorMsg: e.message!.toString()));
      }
    } on SocketException catch (e) {
      emit(AuthPassUpdateFailureState(errorMsg: e.message));
    } catch (e) {
      emit(AuthFailureState(errorMsg: e.toString()));
    }
  }

  getUserData(
      {required DocumentSnapshot<Map<String, dynamic>> userData,
      required String uid,
      required Emitter<AuthState> emit}) async {
    var pref = await SharedPreferences.getInstance();
    if (userData.data() == null) {
      emit(AuthFailureState(errorMsg: "You Don't Have a User Accounts"));
    } else {
      UserModel userModel = UserModel.fromMap(userData.data()!);
      if (userModel.accountType == 'user') {
        pref.setString(SharedPrefConst.uId, uid);
        pref.setString(SharedPrefConst.userType, SharedPrefConst.user);
        emit(AuthSuccesState());
      } else {
        emit(AuthFailureState(errorMsg: "You Don't Have a User Account"));
      }
    }
  }

  FutureOr<void> _authLogOutEvent(
      AuthLogOutEvent event, Emitter<AuthState> emit) async {
    try {
      await auth.signOut();
      var pref = await SharedPreferences.getInstance();
      pref.setString(SharedPrefConst.uId, '');
      pref.setString(SharedPrefConst.userType, '');
     // FirebaseMess
    } on FirebaseAuthException catch (e) {
      emit(AuthFailureState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(AuthPassUpdateFailureState(errorMsg: e.message));
    } catch (e) {
      emit(AuthFailureState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> _authForgetPasswordEvent(
      AuthForgetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: event.email.trim())
          .then((value) {
        emit(AuthUpdatePassSuccess(succesMsg: 'Reset Link Send Succesfully'));
      });
    } on FirebaseAuthException catch (e) {
      emit(AuthPassUpdateFailureState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(AuthPassUpdateFailureState(errorMsg: e.message));
    } catch (e) {
      emit(AuthPassUpdateFailureState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> _authChangePasswordEvent(
      AuthChangePasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      auth
          .signInWithEmailAndPassword(
              email: auth.currentUser!.email!, password: event.oldPassword)
          .then((value) async {
        if (value.user != null) {
          await auth.currentUser!
              .updatePassword(event.newPassword)
              .whenComplete(() => emit(AuthUpdatePassSuccess(
                  succesMsg: 'Password updated successfully')));
        }
      });
    } on FirebaseAuthException catch (e) {
      emit(AuthPassUpdateFailureState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(AuthPassUpdateFailureState(errorMsg: e.message));
    } catch (e) {
      emit(AuthPassUpdateFailureState(errorMsg: e.toString()));
      // showSnackbar(context, e.toString());
      // Navigator.pushReplacementNamed(
      //     context, AppRoutes.profile);
    }
  }
}
