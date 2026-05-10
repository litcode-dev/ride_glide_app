import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/driver.dart';
import '../repositories/driver_repository.dart';

class GetAssignedDriver implements UseCase<Driver, NoParams> {
  final DriverRepository _repository;
  GetAssignedDriver(this._repository);

  @override
  Future<Either<Failure, Driver>> call(NoParams params) {
    return _repository.getAssignedDriver();
  }
}
