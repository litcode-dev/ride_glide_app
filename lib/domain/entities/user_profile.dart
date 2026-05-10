class UserProfile {
  final String id;
  final String name;
  final String phone;
  final double rating;
  final double walletBalance;
  final int tripCount;
  final int avatarHue;

  const UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.rating,
    required this.walletBalance,
    required this.tripCount,
    required this.avatarHue,
  });
}
