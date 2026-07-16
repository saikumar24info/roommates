class ServiceRequest {
  final String id;
  final String userId;
  final String? hostelId;
  final String category;
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;

  const ServiceRequest({
    required this.id,
    required this.userId,
    this.hostelId,
    required this.category,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory ServiceRequest.fromMap(Map<String, dynamic> map) {
    return ServiceRequest(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      hostelId: map['hostel_id'] as String?,
      category: map['category'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      status: map['status'] as String? ?? 'Open',
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
