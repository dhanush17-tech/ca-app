// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ca_appoinment/features/professional/profile/models/pro_account_model.dart';
import 'package:ca_appoinment/features/user/model/user_model.dart';

class BookingScreenArgumnet {
  ProfessionalAccountModel proModel;
  UserModel userModel;
  BookingScreenArgumnet({
    required this.proModel,
    required this.userModel,
  });
}
