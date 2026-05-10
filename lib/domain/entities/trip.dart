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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Trip &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          destination == other.destination &&
          originAddress == other.originAddress &&
          driverName == other.driverName &&
          driverAvatarHue == other.driverAvatarHue &&
          rideType == other.rideType &&
          price == other.price &&
          date == other.date &&
          durationMinutes == other.durationMinutes &&
          rating == other.rating &&
          status == other.status;

  @override
  int get hashCode =>
      id.hashCode ^
      destination.hashCode ^
      originAddress.hashCode ^
      driverName.hashCode ^
      driverAvatarHue.hashCode ^
      rideType.hashCode ^
      price.hashCode ^
      date.hashCode ^
      durationMinutes.hashCode ^
      rating.hashCode ^
      status.hashCode;
}
