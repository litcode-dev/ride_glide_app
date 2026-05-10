import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/local/location_local_datasource.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDatasource _datasource;
  LocationRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<Location>>> searchLocations(String query) async {
    try {
      return Right(await _datasource.searchLocations(query));
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Location>> getCurrentLocation() async {
    try {
      return Right(await _datasource.getCurrentLocation());
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
