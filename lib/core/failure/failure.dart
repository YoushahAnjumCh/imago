abstract class Failure {
  final String? errormessage;
  const Failure({this.errormessage});
}

class ServerFailure extends Failure {
  const ServerFailure(String errormessage) : super(errormessage: errormessage);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(String errormessage)
      : super(errormessage: errormessage);
}
