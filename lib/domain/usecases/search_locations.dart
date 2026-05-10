import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/location.dart';
import '../repositories/location_repository.dart';

class SearchLocationsParams {
  final String query;
  const SearchLocationsParams(this.query);
}

class SearchLocations implements UseCase<List<Location>, SearchLocationsParams> {
  final LocationRepository _repository;
  SearchLocations(this._repository);

  @override
  Future<Either<Failure, List<Location>>> call(SearchLocationsParams params) {
    return _repository.searchLocations(params.query);
  }
}
