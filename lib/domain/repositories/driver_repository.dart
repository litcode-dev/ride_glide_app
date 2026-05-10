import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../entities/driver.dart';

abstract class DriverRepository {
  Future<Either<Failure, Driver>> getAssignedDriver();
}
