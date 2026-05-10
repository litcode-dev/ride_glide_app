import '../../../domain/entities/ride_option.dart';

abstract class RideLocalDatasource {
  Future<List<RideOption>> getRideOptions();
}

class RideLocalDatasourceImpl implements RideLocalDatasource {
  @override
  Future<List<RideOption>> getRideOptions() async => const [
        RideOption(id: '1', name: 'Glide', subtitle: '4 seats · Affordable', eta: '3 min', price: 8.40, badge: 'Most popular'),
        RideOption(id: '2', name: 'Glide XL', subtitle: '6 seats · Extra room', eta: '5 min', price: 12.20),
        RideOption(id: '3', name: 'Glide Lux', subtitle: 'Top-rated drivers', eta: '7 min', price: 16.80),
        RideOption(id: '4', name: 'Glide Eco', subtitle: 'Hybrid + EV only', eta: '4 min', price: 9.10),
      ];
}
