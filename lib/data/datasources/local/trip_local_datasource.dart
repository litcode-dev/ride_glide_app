// lib/data/datasources/local/trip_local_datasource.dart
import '../../../domain/entities/trip.dart';

abstract class TripLocalDatasource {
  Future<List<Trip>> getHistory();
}

class TripLocalDatasourceImpl implements TripLocalDatasource {
  @override
  Future<List<Trip>> getHistory() async => [
        Trip(
          id: 't1', destination: '47 Spring St', originAddress: '128 Mt Prospect Ave',
          driverName: 'Joe Smith', driverAvatarHue: 42, rideType: RideType.glide,
          price: 8.40, date: DateTime(2026, 5, 8, 14, 23), durationMinutes: 12,
          rating: 4.9, status: TripStatus.completed,
        ),
        Trip(
          id: 't2', destination: 'JFK Airport · Term 4', originAddress: '128 Mt Prospect Ave',
          driverName: 'Maria Lopez', driverAvatarHue: 200, rideType: RideType.xl,
          price: 54.20, date: DateTime(2026, 5, 5, 7, 10), durationMinutes: 48,
          rating: 5.0, status: TripStatus.completed,
        ),
        Trip(
          id: 't3', destination: 'Newark Penn Station', originAddress: '47 Spring St',
          driverName: 'Chris Park', driverAvatarHue: 310, rideType: RideType.eco,
          price: 11.80, date: DateTime(2026, 5, 2, 18, 45), durationMinutes: 19,
          rating: 4.7, status: TripStatus.completed,
        ),
        Trip(
          id: 't4', destination: 'Reservoir Park', originAddress: '128 Mt Prospect Ave',
          driverName: 'Sam Reed', driverAvatarHue: 90, rideType: RideType.glide,
          price: 6.20, date: DateTime(2026, 5, 1, 9, 0), durationMinutes: 8,
          status: TripStatus.cancelled,
        ),
        Trip(
          id: 't5', destination: 'Work — Studio', originAddress: '128 Mt Prospect Ave',
          driverName: 'Joe Smith', driverAvatarHue: 42, rideType: RideType.glide,
          price: 9.10, date: DateTime(2026, 4, 28, 8, 30), durationMinutes: 14,
          rating: 4.9, status: TripStatus.completed,
        ),
        Trip(
          id: 't6', destination: '47 Spring St', originAddress: 'Reservoir Park',
          driverName: 'Maria Lopez', driverAvatarHue: 200, rideType: RideType.lux,
          price: 16.80, date: DateTime(2026, 4, 22, 20, 15), durationMinutes: 22,
          rating: 5.0, status: TripStatus.completed,
        ),
        Trip(
          id: 't7', destination: 'Newark Penn Station', originAddress: '128 Mt Prospect Ave',
          driverName: 'Chris Park', driverAvatarHue: 310, rideType: RideType.eco,
          price: 12.40, date: DateTime(2026, 4, 15, 17, 0), durationMinutes: 21,
          rating: 4.6, status: TripStatus.completed,
        ),
        Trip(
          id: 't8', destination: 'JFK Airport · Term 4', originAddress: '47 Spring St',
          driverName: 'Sam Reed', driverAvatarHue: 90, rideType: RideType.xl,
          price: 48.50, date: DateTime(2026, 4, 10, 6, 0), durationMinutes: 55,
          rating: 4.8, status: TripStatus.completed,
        ),
      ];
}
