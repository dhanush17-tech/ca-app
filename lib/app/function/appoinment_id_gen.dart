import 'dart:math';

class IdGenerator {
  static final Random  random = Random();
  static final Set<int>  appoinmentGeneratedIds = {};
  static final Set<int>  transationGeneratedIds = {};
  static final Set<int>  docGeneratedIds = {};
  static final Set<int>  creditOrderIds = {};

  static String appointmentID() {
    int randomNumber;
    do {
      randomNumber = 10000 +  random.nextInt(90000);
    } while ( appoinmentGeneratedIds.contains(randomNumber));

     appoinmentGeneratedIds.add(randomNumber);
    return randomNumber.toString();
  }
  static String transactionID() {
    int randomNumber;
    do {
      randomNumber = 100000 +  random.nextInt(900000);
    } while ( transationGeneratedIds.contains(randomNumber));

     transationGeneratedIds.add(randomNumber);
    return randomNumber.toString();
  }
  static String documentId() {
    int randomNumber;
    do {
      randomNumber = 1000 +  random.nextInt(9000);
    } while ( docGeneratedIds.contains(randomNumber));

     docGeneratedIds.add(randomNumber);
    return randomNumber.toString();
  }
  static String creditOrderId() {
    int randomNumber;
    do {
      randomNumber = 1000 +  random.nextInt(9000);
    } while ( creditOrderIds.contains(randomNumber));

     creditOrderIds.add(randomNumber);
    return randomNumber.toString();
  }
}