import 'dart:async';
import 'dart:io';

import 'package:ca_appoinment/app/function/appoinment_id_gen.dart';
import 'package:ca_appoinment/features/credit/model/succes_credit_model.dart';
import 'package:ca_appoinment/features/credit/repository/repository.dart';
import 'package:ca_appoinment/features/user/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ca_appoinment/app/const/firebase_const.dart';
import 'package:ca_appoinment/features/credit/model/credit_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

part 'credit_event.dart';
part 'credit_state.dart';

class CreditBloc extends Bloc<CreditEvent, CreditState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final Razorpay razorpay;
  final RazorApiRequest repository;
  CreditBloc(this.firestore, this.auth, this.repository, this.razorpay)
      : super(CreditInitial()) {
    on<CreditBuyEvent>(creditBuyEvent);
    on<CreditUseEvent>(creditUseEvent);
    on<CreditFetchEvent>(creditFetchEvent);
  }
  @override
  void onEvent(CreditEvent event) {
    razorpay.clear();
    super.onEvent(event);
  }

  @override
  Future<void> close() {
    razorpay.clear();
    return super.close();
  }

  Future<List<CreditModel>?> fetchCredit() async {
    List<CreditModel> creditList = [];
    var uid = auth.currentUser!.uid;
    await firestore
        .collection(FirebaseConst.userCollection)
        .doc(uid)
        .collection(FirebaseConst.creditCollection)
        .orderBy('purchaseTime', descending: true)
        .get()
        .then(
      (value) {
        for (var each in value.docs) {
          var model = CreditModel.fromMap(each.data());
          creditList.add(model);
        }
      },
    );

    return creditList;
  }

  void _handlePaymentSuccess(
      PaymentSuccessResponse response, SuccesCreditModel model) async {
    // Do something when payment succeeds

    print('myTestingPaymentData :${response.data}');
    String uId = auth.currentUser!.uid;

    await firestore
        .collection(FirebaseConst.userCollection)
        .doc(uId)
        .collection(FirebaseConst.creditCollection)
        .add(CreditModel(
                amount: model.notes!.amount! ~/ 100,
                credit: model.notes!.credit!,
                email: model.notes!.email!,
                name: model.notes!.name!,
                number: model.notes!.number!,
                increase: true,
                uId: uId,
                orderId: response.orderId.toString(),
                purchaseTime: DateTime.now().millisecondsSinceEpoch)
            .toMap());
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    // Do something when payment fails
    print('payment fails');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print('payment external wallet was selected');
  }

  FutureOr<void> creditBuyEvent(
      CreditBuyEvent event, Emitter<CreditState> emit) async {
    emit(CreditLoadingState());
    String uid = auth.currentUser!.uid;
    int totalBalance = 0;
    var userData =
        await firestore.collection(FirebaseConst.userCollection).doc(uid).get();
    var userModel = UserModel.fromMap(userData.data()!);

    try {
      var creditModel = CreditModel(
          amount: event.amount * 100,
          credit: event.credit,
          email: userModel.email!,
          name: userModel.name!,
          number: userModel.number!,
          increase: true,
          uId: auth.currentUser!.uid,
          orderId: IdGenerator.creditOrderId(),
          purchaseTime: DateTime.now().millisecondsSinceEpoch);

      SuccesCreditModel orderDetails = await repository.makeOrder(creditModel);
      var option = {
        'key': 'rzp_test_0UiuDhBYakFrlb',
        'amount': event.amount * 100,
        'name': 'Book Appointment',
        'order_id': orderDetails.id,
        'description':
            'Book Appointment with Charted Accountant and Finacial Manager.',
        'prefill': {
          'contact': '759839025',
          'email': 'test@CaFa.com',
        },
        'timeout': 300,
      };
      razorpay.open(option);
// / Handle This with Credit Screen
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
          (PaymentSuccessResponse response) {
        return _handlePaymentSuccess(response, orderDetails);
      });
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

      ///
      emit(CreditBuySuccesState(option: option));
      // add(CreditFetchEvent());
      var data = await fetchCredit();
      for (var each in data!) {
        if (each.increase) {
          totalBalance += each.credit;
        } else {
          totalBalance -= each.credit;
        }
      }
      await firestore
          .collection(FirebaseConst.userCollection)
          .doc(uid)
          .update({'credit': totalBalance});

      emit(CreditSuccesState(
          model: CreditBalanceModel(balance: totalBalance, history: data)));
    } on FirebaseException catch (e) {
      emit(CreditFailureState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(CreditFailureState(errorMsg: e.message));
    } catch (e) {
      emit(CreditFailureState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> creditFetchEvent(
      CreditFetchEvent event, Emitter<CreditState> emit) async {
    emit(CreditLoadingState());
    String uid = auth.currentUser!.uid;
    int totalBalance = 0;
    try {
      var data = await fetchCredit();
      for (var each in data!) {
        if (each.increase) {
          totalBalance += each.credit;
        } else {
          totalBalance -= each.credit;
        }
      }
      await firestore
          .collection(FirebaseConst.userCollection)
          .doc(uid)
          .update({'credit': totalBalance});

      emit(CreditSuccesState(
          model: CreditBalanceModel(balance: totalBalance, history: data)));
    } on FirebaseException catch (e) {
      emit(CreditFailureState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(CreditFailureState(errorMsg: e.message));
    } catch (e) {
      emit(CreditFailureState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> creditUseEvent(
      CreditUseEvent event, Emitter<CreditState> emit) async {
    emit(CreditLoadingState());
    try {
      String uid = auth.currentUser!.uid;

      if (event.creditModel != null) {
        await firestore
            .collection(FirebaseConst.userCollection)
            .doc(uid)
            .collection(FirebaseConst.creditCollection)
            .add(event.creditModel!.toMap());
      }
      add(CreditFetchEvent());
    } on FirebaseException catch (e) {
      emit(CreditFailureState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(CreditFailureState(errorMsg: e.message));
    } catch (e) {
      emit(CreditFailureState(errorMsg: e.toString()));
    }
  }
}
