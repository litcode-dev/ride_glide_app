import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../entities/location.dart';

abstract class LocationRepository {
  Future<Either<Failure, List<Location>>> searchLocations(String query);
  Future<Either<Failure, Location>> getCurrentLocation();
}
