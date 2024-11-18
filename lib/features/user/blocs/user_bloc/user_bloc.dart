import 'dart:io';

import 'package:ca_appoinment/app/const/firebase_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ca_appoinment/features/user/model/user_model.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FirebaseStorage firebaseStorage;
  UserBloc(
      {required this.firestore,
      required this.firebaseStorage,
      required this.auth})
      : super(UserInitial()) {
    on<UpdateProfileEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        String? uid = auth.currentUser!.uid;
        String? downLoadUrl;
        if (event.profileImgFile != null) {
          var refPath = firebaseStorage
              .ref()
              .child('user')
              .child('profile')
              .child('profilePic_$uid.jpg');
          await refPath.putFile(File(event.profileImgFile!.path));
          downLoadUrl = await refPath.getDownloadURL();
        }

        var updateUserModel = {
          if (event.email != null) 'email': event.email,
          if (event.name != null) 'name': event.name,
          if (event.number != null) 'number': event.number,
          if (event.gender != null) 'gender': event.gender,
          if (event.bithDate != null) 'bithDate': event.bithDate,
          if (event.profileImgFile != null) 'profilePic': downLoadUrl,
        };
        await firestore
            .collection(FirebaseConst.userCollection)
            .doc(uid)
            .update(updateUserModel)
            .then((value) async {
          var userData = await firestore
              .collection(FirebaseConst.userCollection)
              .doc(uid)
              .get();
          var userModel = UserModel.fromMap(userData.data()!);
          emit(UserSuccessState(userModel: userModel));
        });
      } on FirebaseException catch (e) {
        emit(UserFailuerState(errorMsg: e.message!));
      } catch (e) {
        emit(UserFailuerState(errorMsg: e.toString()));
      }
    });

    on<FetchProfileEvent>(
      (event, emit) async {
        emit(UserLoadingState());

        var uId = auth.currentUser!.uid;
        try {
          var userData = await firestore
              .collection(FirebaseConst.userCollection)
              .doc(uId)
              .get();
          var userModel = UserModel.fromMap(userData.data()!);


          
          emit(UserSuccessState(userModel: userModel));
        } on FirebaseException catch (e) {
          emit(UserFailuerState(errorMsg: '${e.message!}?/'));
        } on SocketException catch (e) {
          emit(UserFailuerState(
              errorMsg:
                  'error: ${e.message}\n address: ${e.address}\n port: ${e.port}'));
        } catch (e) {
          emit(UserFailuerState(errorMsg: '$e?'));
        }
      },
    );
  }
}
