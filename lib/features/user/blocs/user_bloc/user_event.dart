// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UpdateProfileEvent extends UserEvent {
  String? email;
  String? name;
  String? number;
  String? gender;
  String? bithDate;
  File? profileImgFile;
  UpdateProfileEvent({
     this.email,
     this.name,
     this.number,
     this.gender,
     this.bithDate,
     this.profileImgFile,
  });
  
}

class FetchProfileEvent extends UserEvent {

}
