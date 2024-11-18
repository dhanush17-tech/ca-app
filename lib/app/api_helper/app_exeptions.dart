// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppExeptions {
  String title;
  String body;
  AppExeptions({
    required this.title,
    required this.body,
  });
  String toErrorMessage() => '$title : $body';
}

class FetchDataException extends AppExeptions {
  FetchDataException({required String body})
      : super(body: body, title: 'Error During Communication');
}

class BadRequestException extends AppExeptions {
  BadRequestException({required String body})
      : super(body: body, title: 'Invalid Request');
}

class UnauthorizedException extends AppExeptions {
  UnauthorizedException({required String body})
      : super(body: body, title: 'Unauthorized');
}

class InvaliInputException extends AppExeptions {
  InvaliInputException({required String body})
      : super(body: body, title: 'Invalid Input');
}
