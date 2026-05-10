import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/trip.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/local/trip_local_datasource.dart';

class TripRepositoryImpl implements TripRepository {
  final TripLocalDatasource _datasource;
  TripRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<Trip>>> getHistory() async {
    try {
      return Right(await _datasource.getHistory());
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
