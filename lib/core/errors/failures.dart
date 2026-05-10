abstract class Failure {
  const Failure(this.message);
  final String message;
}

class ServerFailure extends Failure {
  const ServerFailure() : super('Server error');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure() : super('Not found');
}
