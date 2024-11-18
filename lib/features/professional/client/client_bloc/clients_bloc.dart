import 'dart:io';

import 'package:ca_appoinment/app/const/firebase_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ca_appoinment/features/user/model/user_model.dart';
import 'package:equatable/equatable.dart';

part 'clients_event.dart';
part 'clients_state.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ClientsBloc(this.firestore, this.auth) : super(ClientsInitial()) {
    on<ClientsFetchEvent>((event, emit) async {
      Set<String> uniqueUserIds = {};
      List<UserModel> clients = [];
      emit(ClientsLoadingState());
      try {
        await firestore
            .collection(FirebaseConst.professionCollection)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConst.bookingCollection)
            .get()
            .then((value) async {
          if (value.docs.isNotEmpty) {
            for (var eachClient in value.docs) {
              uniqueUserIds.add(eachClient.data()['userId']);
            }

            var userData = await firestore
                .collection(FirebaseConst.userCollection)
                .where('uId', whereIn: uniqueUserIds.toList())
                .get();

            for (var user in userData.docs) {
              var userModel = UserModel.fromMap(user.data());
              clients.add(userModel);
            }
          }
          emit(ClientsSuccesState(clients: clients));
        });
      } on FirebaseException catch (e) {
        emit(ClientsFailuerState(errorMsg: e.message!));
      } on SocketException catch (e) {
        emit(ClientsFailuerState(errorMsg: e.message));
      } catch (e) {
        emit(ClientsFailuerState(errorMsg: e.toString()));
      }
    });
  }
}
