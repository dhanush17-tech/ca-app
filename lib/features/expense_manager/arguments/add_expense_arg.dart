// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ca_appoinment/features/expense_manager/model/transaction_model.dart';

class AddExpenseArgument {
  TransactionModel? transactionModel;
  bool isUpdate;
  AddExpenseArgument({
     this.transactionModel,
     this.isUpdate=false,
  });
}
