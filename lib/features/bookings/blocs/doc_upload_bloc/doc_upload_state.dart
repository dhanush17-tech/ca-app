// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'doc_upload_bloc.dart';

sealed class DocUploadState extends Equatable {
  const DocUploadState();

  @override
  List<Object> get props => [];
}

class DocUploadInitial extends DocUploadState {}

class DocUploadLoadingState extends DocUploadState {}

class DocUploadFailuerState extends DocUploadState {
  String errorMsg;
  DocUploadFailuerState({
    required this.errorMsg,
  });
}

class DocUploadSuccesState extends DocUploadState { BookingTimeModel docs;
  DocUploadSuccesState({
    required this.docs,
  });}

