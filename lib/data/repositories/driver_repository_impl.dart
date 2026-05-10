import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/driver.dart';
import '../../domain/repositories/driver_repository.dart';
import '../datasources/local/driver_local_datasource.dart';

class DriverRepositoryImpl implements DriverRepository {
  final DriverLocalDatasource _datasource;
  DriverRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, Driver>> getAssignedDriver() async {
    try {
      return Right(await _datasource.getAssignedDriver());
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
