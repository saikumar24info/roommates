class HostelSpecification {
  final String id;
  final String hostelId;
  final String title;
  final String description;
  final String iconKey;
  final int sortOrder;
  final bool isEnabled;

  const HostelSpecification({
    required this.id,
    required this.hostelId,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.sortOrder,
    required this.isEnabled,
  });

  factory HostelSpecification.fromMap(Map<String, dynamic> map) {
    return HostelSpecification(
      id: map['id'] as String,
      hostelId: map['hostel_id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      iconKey: map['icon_key'] as String? ?? 'wifi',
      sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
      isEnabled: map['is_enabled'] as bool? ?? true,
    );
  }
}
