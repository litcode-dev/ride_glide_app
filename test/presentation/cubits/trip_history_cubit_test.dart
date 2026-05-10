import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ride_app/core/errors/failures.dart';
import 'package:ride_app/domain/entities/trip.dart';
import 'package:ride_app/domain/repositories/trip_repository.dart';
import 'package:ride_app/domain/usecases/get_trip_history.dart';
import 'package:ride_app/presentation/cubits/trip_history_cubit.dart';

class _FakeTripRepository implements TripRepository {
  final Either<Failure, List<Trip>> result;
  _FakeTripRepository(this.result);
  @override
  Future<Either<Failure, List<Trip>>> getHistory() async => result;
}

void main() {
  final trip = Trip(
    id: '1',
    destination: 'Spring St',
    originAddress: 'Home',
    driverName: 'Joe',
    driverAvatarHue: 42,
    rideType: RideType.glide,
    price: 8.40,
    date: DateTime(2026, 5, 1),
    durationMinutes: 12,
    rating: 4.9,
    status: TripStatus.completed,
  );

  test('emits trips on successful load', () async {
    final cubit = TripHistoryCubit(GetTripHistory(_FakeTripRepository(Right([trip]))));
    await cubit.load();
    expect(cubit.state.trips, [trip]);
    expect(cubit.state.isLoading, false);
    expect(cubit.state.error, isNull);
  });

  test('emits error on failure', () async {
    final cubit = TripHistoryCubit(GetTripHistory(_FakeTripRepository(Left(ServerFailure()))));
    await cubit.load();
    expect(cubit.state.trips, isEmpty);
    expect(cubit.state.isLoading, false);
    expect(cubit.state.error, 'Server error');
  });
}
