import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/trip.dart';
import '../repositories/trip_repository.dart';

class GetTripHistory implements UseCase<List<Trip>, NoParams> {
  final TripRepository _repository;
  GetTripHistory(this._repository);

  @override
  Future<Either<Failure, List<Trip>>> call(NoParams params) =>
      _repository.getHistory();
}
