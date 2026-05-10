import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/ride_option.dart';
import '../../domain/repositories/ride_repository.dart';
import '../datasources/local/ride_local_datasource.dart';

class RideRepositoryImpl implements RideRepository {
  final RideLocalDatasource _datasource;
  RideRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<RideOption>>> getRideOptions() async {
    try {
      return Right(await _datasource.getRideOptions());
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> bookRide(String rideOptionId) async {
    try {
      return const Right(unit);
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
