import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../entities/trip.dart';

abstract class TripRepository {
  Future<Either<Failure, List<Trip>>> getHistory();
}
