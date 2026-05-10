import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/user_repository.dart';

class GetUserProfile implements UseCase<UserProfile, NoParams> {
  final UserRepository _repository;
  GetUserProfile(this._repository);

  @override
  Future<Either<Failure, UserProfile>> call(NoParams params) {
    return _repository.getProfile();
  }
}
