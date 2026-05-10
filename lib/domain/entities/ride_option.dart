class RideOption {
  final String id;
  final String name;
  final String subtitle;
  final String eta;
  final double price;
  final String badge;

  const RideOption({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.eta,
    required this.price,
    this.badge = '',
  });
}
