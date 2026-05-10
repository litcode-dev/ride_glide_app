import '../../../domain/entities/driver.dart';
import '../../../domain/entities/vehicle.dart';

abstract class DriverLocalDatasource {
  Future<Driver> getAssignedDriver();
}

class DriverLocalDatasourceImpl implements DriverLocalDatasource {
  @override
  Future<Driver> getAssignedDriver() async => const Driver(
        id: 'd1',
        name: 'Joe Smith',
        rating: 4.92,
        tripCount: 1284,
        etaMinutes: 2,
        avatarHue: 42,
        vehicle: Vehicle(
          description: 'White Tesla Model 3',
          plate: 'NJ · 7M3 K42',
          pickup: '128 Mt Prospect Ave',
        ),
      );
}
