// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'doc_upload_bloc.dart';

sealed class DocUploadEvent extends Equatable {
  const DocUploadEvent();

  @override
  List<Object> get props => [];
}

class UploadUserDoc extends DocUploadEvent {
  File? aadhaarCard;
  File? panCard;
  File? bankStatements;
  BookingTimeModel bookingModel;
  UploadUserDoc({
    this.aadhaarCard,
    this.panCard,
    this.bankStatements,
    required this.bookingModel,
  });
}

class UploadCaDoc extends DocUploadEvent {
  File? files;
  String? docName;
  BookingTimeModel bookingModel;
  UploadCaDoc({
    this.files,
    this.docName,
    required this.bookingModel,
  });
}

class FetchUserDoc extends DocUploadEvent {
  BookingTimeModel bookingModel;
  FetchUserDoc({
    required this.bookingModel,
  });
}
