import 'dart:async';
import 'dart:io';
import 'package:ca_appoinment/app/const/firebase_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ca_appoinment/features/professional/profile/models/pro_account_model.dart';
import 'package:equatable/equatable.dart';
part 'pro_user_event.dart';
part 'pro_user_state.dart';

class ProUserBloc extends Bloc<ProUserEvent, ProUserState> {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  ProUserBloc(this.firestore, this.auth, this.firebaseStorage)
      : super(ProUserInitial()) {
    on<ProUserFetchProfileEvent>(_proUserProfileFetchEvent);
    on<ProUserUpdateProfileEvent>(_proUserUpdateProfileEvent);
    on<ProUserCheckVerifyEvent>(_proUserCheckVerifyEvent);
  }

  FutureOr<void> _proUserProfileFetchEvent(
      ProUserFetchProfileEvent event, Emitter<ProUserState> emit) async {
    emit(ProUserLoadingState());
    try {
      await firestore
          .collection(FirebaseConst.professionCollection)
          .withConverter<ProfessionalAccountModel>(
            fromFirestore: (snapshot, options) =>
                ProfessionalAccountModel.fromMap(snapshot.data()!),
            toFirestore: (value, options) => value.toMap(),
          )
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) async {
        emit(ProUserSuccessState(proModel: value.data()!));
      });
    } on FirebaseException catch (e) {
      emit(ProUserFailuerState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(ProUserFailuerState(errorMsg: e.message));
    } catch (e) {
      emit(ProUserFailuerState(errorMsg: e.toString()));
    }
  }

  Future<ProfessionalAccountModel> updateProfile(
      Map<String, dynamic> map) async {
    await firestore
        .collection(FirebaseConst.professionCollection)
        .withConverter<ProfessionalAccountModel>(
          fromFirestore: (snapshot, options) =>
              ProfessionalAccountModel.fromMap(snapshot.data()!),
          toFirestore: (value, options) => value.toMap(),
        )
        .doc(auth.currentUser!.uid)
        .update(map);
    var model = await firestore
        .collection(FirebaseConst.professionCollection)
        .withConverter<ProfessionalAccountModel>(
          fromFirestore: (snapshot, options) =>
              ProfessionalAccountModel.fromMap(snapshot.data()!),
          toFirestore: (value, options) => value.toMap(),
        )
        .doc(auth.currentUser!.uid)
        .get();
    return model.data()!;
  }

  FutureOr<void> _proUserUpdateProfileEvent(
      ProUserUpdateProfileEvent event, Emitter<ProUserState> emit) async {
    emit(ProUserLoadingState());
    try {
      String uId = auth.currentUser!.uid;

      late Map<String, dynamic> updateValues = {};
   
        if (event.newData!.userName != null ||
            event.newData!.userName!.isEmpty) {
          updateValues['userName'] = event.newData!.userName;
        }
        if (event.newData!.email != null || event.newData!.email!.isEmpty) {
          updateValues['email'] = event.newData!.email;
        }
        if (event.newData!.phoneNumber != null ||
            event.newData!.phoneNumber!.isEmpty) {
          updateValues['phoneNumber'] = event.newData!.phoneNumber;
        }
        if (event.newData!.address != null || event.newData!.address!.isEmpty) {
          updateValues['address'] = event.newData!.address;
        }
         if (event.profileImgFile != null) {
        var refPath = firebaseStorage
            .ref()
            .child(FirebaseConst.professionCollection)
            .child('Pro_profilePic_$uId.jpg');

        await refPath.putFile(File(event.profileImgFile!.path));
        String? downLoadUrl = await refPath.getDownloadURL();

        // updateValues = event.newData!.copyWith(profileUrl: downLoadUrl).toMap();
         if (event.profileImgFile != null ) {
          updateValues['profileUrl'] = downLoadUrl;
        }
      }
      ProfessionalAccountModel dataModel = await updateProfile(updateValues);

      emit(ProUserSuccessState(proModel: dataModel));
    } on FirebaseException catch (e) {
      emit(ProUserFailuerState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(ProUserFailuerState(errorMsg: e.message));
    } catch (e) {
      emit(ProUserFailuerState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> _proUserCheckVerifyEvent(
      ProUserCheckVerifyEvent event, Emitter<ProUserState> emit) async {
    emit(ProUserLoadingState());
    try {
      late Map<String, dynamic> updateValues;
      if (event.newData!.title!.isNotEmpty &&
          event.newData!.description!.isNotEmpty) {
        updateValues = event.newData!.copyWith(verified: true).toMap();
      }
      if (event.newData!.title!.isEmpty ||
          event.newData!.description!.isEmpty ||
          event.newData!.title == null ||
          event.newData!.description == null) {
        updateValues = event.newData!.copyWith(verified: false).toMap();
      }
      ProfessionalAccountModel dataModel = await updateProfile(updateValues);

      emit(ProUserSuccessState(proModel: dataModel));
    } on FirebaseException catch (e) {
      emit(ProUserFailuerState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(ProUserFailuerState(errorMsg: e.message));
    } catch (e) {
      emit(ProUserFailuerState(errorMsg: e.toString()));
    }
  }
}
