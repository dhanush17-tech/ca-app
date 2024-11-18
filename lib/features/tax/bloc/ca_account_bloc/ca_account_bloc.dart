import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ca_appoinment/app/const/firebase_const.dart';
import 'package:ca_appoinment/features/professional/profile/models/pro_account_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'ca_account_event.dart';
part 'ca_account_state.dart';

class CaAccountsBloc extends Bloc<CaAccountEvent, CaAccountState> {
  final FirebaseFirestore firestore;
  CaAccountsBloc(this.firestore) : super(CaAccountInitial()) {
    on<CaAccountsFetchEvent>((event, emit) async {
      emit(CaAccountsLoadingState());
      List<ProfessionalAccountModel> accounts = [];
      try {
        await firestore
            .collection(FirebaseConst.professionCollection)
            .where('accountType', isEqualTo: 'CA')
              .where('verified',isEqualTo: true)
            .get()
            .then((value) {
          for (var each in value.docs) {
            accounts.add(ProfessionalAccountModel.fromMap(each.data()));
          }
          emit(CaAccountsSuccesState(accounts: accounts));
        });
      } on FirebaseException catch (e) {
        emit(CaAccountsFailuerState(errorMsg: e.message!));
      } on SocketException catch (e) {
        emit(CaAccountsFailuerState(errorMsg: e.message));
      } catch (e) {
        emit(CaAccountsFailuerState(errorMsg: e.toString()));
      }
    });
  }
}
