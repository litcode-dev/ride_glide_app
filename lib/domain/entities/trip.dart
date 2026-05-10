// lib/domain/entities/trip.dart
enum RideType { glide, xl, lux, eco }
enum TripStatus { completed, cancelled }

class Trip {
  final String id;
  final String destination;
  final String originAddress;
  final String driverName;
  final int driverAvatarHue;
  final RideType rideType;
  final double price;
  final DateTime date;
  final int durationMinutes;
  final double? rating;
  final TripStatus status;

  const Trip({
    required this.id,
    required this.destination,
    required this.originAddress,
    required this.driverName,
    required this.driverAvatarHue,
    required this.rideType,
    required this.price,
    required this.date,
    required this.durationMinutes,
    this.rating,
    required this.status,
  });
}
