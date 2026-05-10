import 'vehicle.dart';

class Driver {
  final String id;
  final String name;
  final double rating;
  final int tripCount;
  final int etaMinutes;
  final int avatarHue;
  final Vehicle vehicle;

  const Driver({
    required this.id,
    required this.name,
    required this.rating,
    required this.tripCount,
    required this.etaMinutes,
    required this.avatarHue,
    required this.vehicle,
  });
}
