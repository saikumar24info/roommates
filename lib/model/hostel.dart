class Hostel {
  final String id;
  final String name;
  final String address;
  final String city;
  final String area;

  const Hostel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.area,
  });

  factory Hostel.fromMap(Map<String, dynamic> map) {
    return Hostel(
      id: map['id'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      city: map['city'] as String? ?? 'Hyderabad',
      area: map['area'] as String? ?? 'KPHB',
    );
  }
}
