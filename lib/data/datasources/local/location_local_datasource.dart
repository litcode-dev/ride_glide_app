import '../../../domain/entities/location.dart';

abstract class LocationLocalDatasource {
  Future<List<Location>> searchLocations(String query);
  Future<Location> getCurrentLocation();
}

class LocationLocalDatasourceImpl implements LocationLocalDatasource {
  static const _suggestions = [
    Location(id: '1', name: 'Home', address: '128 Mt Prospect Ave', isFavorite: true, type: LocationType.home),
    Location(id: '2', name: 'Work — Studio', address: '47 Spring St, Floor 4', type: LocationType.work),
    Location(id: '3', name: 'Reservoir Park', address: '2.1 mi · Outdoor', type: LocationType.landmark),
    Location(id: '4', name: 'Newark Penn Station', address: 'Raymond Plaza W', type: LocationType.transit),
    Location(id: '5', name: 'JFK Airport · Term 4', address: r'32 mi · ~$54', type: LocationType.airport),
  ];

  @override
  Future<List<Location>> searchLocations(String query) async => _suggestions;

  @override
  Future<Location> getCurrentLocation() async => const Location(
        id: '0',
        name: 'Current Location',
        address: '128 Mt Prospect Ave',
        type: LocationType.home,
      );
}
