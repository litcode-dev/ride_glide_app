import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/ride_repository.dart';

class BookRideParams {
  final String rideOptionId;
  const BookRideParams(this.rideOptionId);
}

class BookRide implements UseCase<Unit, BookRideParams> {
  final RideRepository _repository;
  BookRide(this._repository);

  @override
  Future<Either<Failure, Unit>> call(BookRideParams params) {
    return _repository.bookRide(params.rideOptionId);
  }
}
