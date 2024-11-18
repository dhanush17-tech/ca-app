// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'pro_user_bloc.dart';

sealed class ProUserEvent extends Equatable {
  const ProUserEvent();

  @override
  List<Object> get props => [];
}

class ProUserFetchProfileEvent extends ProUserEvent {}

class ProUserUpdateProfileEvent extends ProUserEvent {
  ProfessionalAccountModel? newData;
  File? profileImgFile;
  ProUserUpdateProfileEvent({
     this.newData,
    this.profileImgFile,
  });
}

class ProUserCheckVerifyEvent extends ProUserEvent {
  ProfessionalAccountModel? newData;
  ProUserCheckVerifyEvent({
     this.newData,
  });
}
