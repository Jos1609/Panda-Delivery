class DeliveryAddress {
  final String id;
  final String name;
  final String address;
  final String reference;
  final double lat;
  final double lng;
  final bool isDefault;

  DeliveryAddress({
    required this.id,
    required this.name,
    required this.address,
    required this.reference,
    required this.lat,
    required this.lng,
    this.isDefault = false,
  });
}