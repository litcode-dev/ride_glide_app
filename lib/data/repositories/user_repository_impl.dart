import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local/user_local_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDatasource _datasource;
  UserRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      return Right(await _datasource.getProfile());
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
