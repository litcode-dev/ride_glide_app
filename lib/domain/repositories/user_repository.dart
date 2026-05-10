import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../entities/user_profile.dart';

abstract class UserRepository {
  Future<Either<Failure, UserProfile>> getProfile();
}
