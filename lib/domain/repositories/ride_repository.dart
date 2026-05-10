import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../entities/ride_option.dart';

abstract class RideRepository {
  Future<Either<Failure, List<RideOption>>> getRideOptions();
  Future<Either<Failure, Unit>> bookRide(String rideOptionId);
}
