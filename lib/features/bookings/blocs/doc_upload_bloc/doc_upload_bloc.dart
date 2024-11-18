// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:ca_appoinment/features/bookings/model/booking_time_model.dart';
import 'package:ca_appoinment/app/const/firebase_const.dart';
import 'package:ca_appoinment/app/function/appoinment_id_gen.dart';
import 'package:ca_appoinment/features/professional/profile/models/document_model.dart';
import 'package:ca_appoinment/features/bookings/model/required_doc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'doc_upload_event.dart';
part 'doc_upload_state.dart';

class DocUploadBloc extends Bloc<DocUploadEvent, DocUploadState> {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  DocUploadBloc(this.auth, this.firestore, this.storage)
      : super(DocUploadInitial()) {
    on<UploadUserDoc>(_uploadUserDoc);
    on<FetchUserDoc>(_fetchUserDoc);
    on<UploadCaDoc>(_uploadCaDoc);
  }

  FutureOr<void> _uploadUserDoc(
      UploadUserDoc event, Emitter<DocUploadState> emit) async {
    emit(DocUploadLoadingState());
    try {
      DocumentModel? aadhaarModel;
      DocumentModel? panModel;
      DocumentModel? bankModel;
      String? uid = auth.currentUser!.uid;

      var docChild = storage
          .ref()
          .child(FirebaseConst.documentCollection)
          .child(event.bookingModel.userId!);
      if (event.aadhaarCard != null) {
        var urlPath = docChild.child('${event.bookingModel.serviceID}_AadhaarCard.jpg');
        await urlPath.putFile(File(event.aadhaarCard!.path));
        var url = await urlPath.getDownloadURL();
        aadhaarModel = DocumentModel(
            uploadTime: DateTime.now().millisecondsSinceEpoch,
            docId: '${IdGenerator.documentId()}aadhaar',
            name: 'Aadhaar Card',
            url: url);
      }
      if (event.panCard != null) {
        var urlPath = docChild.child('${event.bookingModel.serviceID}_panCard.jpg');
        await urlPath.putFile(File(event.panCard!.path));
        var url = await urlPath.getDownloadURL();
        panModel = DocumentModel(
            uploadTime: DateTime.now().millisecondsSinceEpoch,
            docId: '${IdGenerator.documentId()}panCard',
            name: 'Pan Card',
            url: url);
      }

      if (event.bankStatements != null) {
        var urlPath = docChild.child('${event.bookingModel.serviceID}_bankStatements.jpg');
        await urlPath.putFile(File(event.bankStatements!.path));
        var url = await urlPath.getDownloadURL();
        bankModel = DocumentModel(
            uploadTime: DateTime.now().millisecondsSinceEpoch,
            docId: '${IdGenerator.documentId()}bankStatements',
            name: 'Bank Statement',
            url: url);
      }

      var appointment = await firestore
          .collection(FirebaseConst.professionCollection)
          .doc(event.bookingModel.proId)
          .collection(FirebaseConst.bookingCollection)
          .doc(event.bookingModel.serviceID)
          .update({
        'userDocs': RequiredTaxDoc(
                aadhaarCard: aadhaarModel!,
                panCard: panModel,
                bankStatement: bankModel)
            .toMap()
      }).then((value) async {
        // var data = await firestore
        //     .collection(FirebaseConst.professionCollection)
        //     .doc(event.bookingModel.proId)
        //     .collection(FirebaseConst.bookingCollection)
        //     .doc(event.bookingModel.serviceID)
        //     .get();
        var model = await fetchData(event.bookingModel);
        emit(DocUploadSuccesState(docs: model));
      });
    } on FirebaseException catch (e) {
      emit(DocUploadFailuerState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(DocUploadFailuerState(errorMsg: e.message));
    } catch (e) {
      emit(DocUploadFailuerState(errorMsg: e.toString()));
    }
  }

  Future<BookingTimeModel> fetchData(BookingTimeModel bookingModel) async {
    late BookingTimeModel docModel;
    var data = await firestore
        .collection(FirebaseConst.professionCollection)
        .doc(bookingModel.proId)
        .collection(FirebaseConst.bookingCollection)
            .doc(bookingModel.serviceID)
        .get();
    var model = BookingTimeModel.fromMap(data.data()!);
    docModel = model;
    return docModel;
  }

  FutureOr<void> _fetchUserDoc(
      FetchUserDoc event, Emitter<DocUploadState> emit) async {
    emit(DocUploadLoadingState());
    String? uid = auth.currentUser!.uid;
    try {
      var docs = await fetchData(event.bookingModel);
      emit(DocUploadSuccesState(docs: docs));
    } on FirebaseException catch (e) {
      emit(DocUploadFailuerState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(DocUploadFailuerState(errorMsg: e.message));
    } catch (e) {
      emit(DocUploadFailuerState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> _uploadCaDoc(
      UploadCaDoc event, Emitter<DocUploadState> emit) async {
    emit(DocUploadLoadingState());
    try {
      if (event.files != null) {
        String? uid = auth.currentUser!.uid;
        DocumentModel file;
        var docChild = storage
            .ref()
            .child(FirebaseConst.documentCollection)
            .child(event.bookingModel.userId!);

        var urlPath = docChild.child('${event.bookingModel.serviceID}_${event.docName}.jpg');
        await urlPath.putFile(File(event.files!.path));
        var url = await urlPath.getDownloadURL();
        file = DocumentModel(
            uploadTime: DateTime.now().millisecondsSinceEpoch,
            docId: '${IdGenerator.documentId()} ${event.docName}',
            name: event.docName,
            url: url);

        var appointment = await firestore
            .collection(FirebaseConst.professionCollection)
            .doc(event.bookingModel.proId)
            .collection(FirebaseConst.bookingCollection)
            .doc(event.bookingModel.serviceID)
            .update({'caDocs': file.toMap()}).then((value) async {
          var model = await fetchData(event.bookingModel);
          emit(DocUploadSuccesState(docs: model));
        });
      }
    } on FirebaseException catch (e) {
      emit(DocUploadFailuerState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(DocUploadFailuerState(errorMsg: e.message));
    } catch (e) {
      emit(DocUploadFailuerState(errorMsg: e.toString()));
    }
  }
}
