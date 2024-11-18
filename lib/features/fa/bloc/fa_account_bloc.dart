import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ca_appoinment/app/const/firebase_const.dart';
import 'package:ca_appoinment/features/professional/profile/models/pro_account_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'fa_account_event.dart';
part 'fa_account_state.dart';

class FaAccountBloc extends Bloc<FaAccountEvent, FaAccountState> {
  final FirebaseFirestore firestore;
  FaAccountBloc(this.firestore) : super(FaAccountInitial()) {
    on<FaAccountFetchEvent>((event, emit) async {
      emit(FaAccountLoadingState());
      List<ProfessionalAccountModel> accounts = [];
      try {
        await firestore
            .collection(FirebaseConst.professionCollection)
            .where('accountType', isEqualTo: 'FA')
            .get()
            .then((value) {
          for (var each in value.docs) {
            accounts.add(ProfessionalAccountModel.fromMap(each.data()));
          }
          emit(FaAccountSuccesState(accounts: accounts));
        });
      } on FirebaseException catch (e) {
        emit(FaAccountFailuerState(errorMsg: e.message!));
      } on SocketException catch (e) {
        emit(FaAccountFailuerState(errorMsg: e.message));
      } catch (e) {
        emit(FaAccountFailuerState(errorMsg: e.toString()));
      }
    });
  }
}
