import 'dart:async';
import 'dart:io';

import 'package:ca_appoinment/app/const/firebase_const.dart';
import 'package:ca_appoinment/app/const/shared_prefrence.dart';
import 'package:ca_appoinment/features/professional/profile/models/pro_account_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'professional_account_auth_event.dart';
part 'professional_account_auth_state.dart';

class ProfessionalAccountAuthBloc
    extends Bloc<ProfessionalAccountAuthEvent, ProfessionalAccountAuthState> {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ProfessionalAccountAuthBloc({required this.auth, required this.firestore})
      : super(ProfessionalAccountAuthInitial()) {
    on<ProfessionalSignUpEvent>(_authSignUpEvent);
    on<ProfessionalLoginEvent>(_authLoginEvent);
  }

  FutureOr<void> _authSignUpEvent(ProfessionalSignUpEvent event,
      Emitter<ProfessionalAccountAuthState> emit) async {
    emit(ProfessionalAccountAuthLoadingState());
    try {
      var value = await auth.createUserWithEmailAndPassword(
          email: event.email, password: event.password);
      if (value.user != null) {
        String? uId = value.user!.uid;
        ProfessionalAccountModel professionalModel = ProfessionalAccountModel(
          email: event.email,
          userName: event.name,
          nfToken: event.nfToken,
          accountType: event.accountType,
          createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
          online: true,
          lastOnline: DateTime.now().millisecondsSinceEpoch.toString(),
          phoneNumber: event.number,
          userId: value.user!.uid,
        );
        await firestore
            .collection(FirebaseConst.professionCollection)
            .doc(value.user!.uid)
            .set(professionalModel.toMap())
            .whenComplete(() async {
          var pref = await SharedPreferences.getInstance();
          pref.setString(SharedPrefConst.uId, uId);
          pref.setString(
              SharedPrefConst.userType, SharedPrefConst.professional);
          emit(ProfessionalAccountAuthSuccesState(
              professionalAccountModel: professionalModel));
        });
      }
    } on FirebaseAuthException catch (e) {
      emit(ProfessionalAccountAuthFailuerState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(ProfessionalAccountAuthFailuerState(errorMsg: e.message));
    } catch (e) {
      emit(ProfessionalAccountAuthFailuerState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> _authLoginEvent(ProfessionalLoginEvent event,
      Emitter<ProfessionalAccountAuthState> emit) async {
    emit(ProfessionalAccountAuthLoadingState());
    try {
      await auth
          .signInWithEmailAndPassword(
              email: event.email, password: event.password)
          .then((value) async {
        var pref = await SharedPreferences.getInstance();
        await firestore
            .collection(FirebaseConst.professionCollection)
            .doc(value.user!.uid)
            .update({'proNfToken': event.nfToken});
        await firestore
            .collection(FirebaseConst.professionCollection)
            .doc(value.user!.uid)
            .get()
            .then((userData) {
          if (userData.data() == null) {
            emit(ProfessionalAccountAuthFailuerState(
                errorMsg: "You Don't Have a Professional Account "));
          } else {
            ProfessionalAccountModel userModel =
                ProfessionalAccountModel.fromMap(userData.data()!);
            if (userModel.accountType == 'CA' ||
                userModel.accountType == 'FA') {
              emit(ProfessionalAccountAuthSuccesState());
              
            pref.setString(SharedPrefConst.uId, value.user!.uid);
            pref.setString(
                SharedPrefConst.userType, SharedPrefConst.professional);
            } else {
              emit(ProfessionalAccountAuthFailuerState(
                  errorMsg: "You Don't Have Professional Account"));
            }
          }
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(ProfessionalAccountAuthFailuerState(errorMsg: 'No user found'));
      } else if (e.code == 'wrong-password') {
        emit(ProfessionalAccountAuthFailuerState(errorMsg: 'Wrong password'));
      } else {
        emit(ProfessionalAccountAuthFailuerState(
            errorMsg: e.message!.toString()));
      }
    } on SocketException catch (e) {
      emit(ProfessionalAccountAuthFailuerState(errorMsg: e.message));
    } catch (e) {
      emit(ProfessionalAccountAuthFailuerState(errorMsg: e.toString()));
    }
  }
}
