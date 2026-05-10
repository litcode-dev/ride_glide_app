import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/ride_option.dart';
import '../repositories/ride_repository.dart';

class GetRideOptions implements UseCase<List<RideOption>, NoParams> {
  final RideRepository _repository;
  GetRideOptions(this._repository);

  @override
  Future<Either<Failure, List<RideOption>>> call(NoParams params) {
    return _repository.getRideOptions();
  }
}
