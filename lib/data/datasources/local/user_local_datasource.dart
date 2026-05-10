import '../../../domain/entities/user_profile.dart';

abstract class UserLocalDatasource {
  Future<UserProfile> getProfile();
}

class UserLocalDatasourceImpl implements UserLocalDatasource {
  @override
  Future<UserProfile> getProfile() async => const UserProfile(
        id: 'u1',
        name: 'Alex Hales',
        phone: '+46 16 755 7287',
        rating: 4.95,
        walletBalance: 29.00,
        tripCount: 148,
        avatarHue: 22,
      );
}
