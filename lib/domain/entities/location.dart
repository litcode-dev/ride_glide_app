enum LocationType { home, work, landmark, transit, airport }

class Location {
  final String id;
  final String name;
  final String address;
  final bool isFavorite;
  final LocationType type;

  const Location({
    required this.id,
    required this.name,
    required this.address,
    this.isFavorite = false,
    required this.type,
  });
}
