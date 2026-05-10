import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ride_app/core/errors/failures.dart';
import 'package:ride_app/core/usecases/usecase.dart';
import 'package:ride_app/domain/entities/trip.dart';
import 'package:ride_app/domain/repositories/trip_repository.dart';
import 'package:ride_app/domain/usecases/get_trip_history.dart';

class _FakeTripRepository implements TripRepository {
  final Either<Failure, List<Trip>> result;
  _FakeTripRepository(this.result);

  @override
  Future<Either<Failure, List<Trip>>> getHistory() async => result;
}

void main() {
  test('returns trips from repository', () async {
    final trip = Trip(
      id: '1', destination: 'Spring St', originAddress: 'Home',
      driverName: 'Joe', driverAvatarHue: 42, rideType: RideType.glide,
      price: 8.40, date: DateTime(2026, 5, 1), durationMinutes: 12,
      rating: 4.9, status: TripStatus.completed,
    );
    final useCase = GetTripHistory(_FakeTripRepository(Right([trip])));
    final result = await useCase(const NoParams());
    expect(result.getOrElse((_) => []), [trip]);
  });

  test('returns failure when repository fails', () async {
    final useCase = GetTripHistory(_FakeTripRepository(Left(ServerFailure())));
    final result = await useCase(const NoParams());
    expect(result.isLeft(), true);
  });
}
