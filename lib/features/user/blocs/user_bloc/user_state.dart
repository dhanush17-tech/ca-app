// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

class UserLoadingState extends UserState {}

class UserSuccessState extends UserState {
  UserModel userModel;
  UserSuccessState({
    required this.userModel,
  });
}

class UserFailuerState extends UserState {
  String errorMsg;
  UserFailuerState({
    required this.errorMsg,
  });
}
