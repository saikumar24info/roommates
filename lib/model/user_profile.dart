class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? jobTitle;
  final String hostelId;
  final String hostelName;
  final String hostelAddress;
  final String sharingTypeId;
  final String sharingLabel;
  final double amount;
  final String paymentDate;
  final bool isAdmin;

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.jobTitle,
    required this.hostelId,
    required this.hostelName,
    required this.hostelAddress,
    required this.sharingTypeId,
    required this.sharingLabel,
    required this.amount,
    required this.paymentDate,
    required this.isAdmin,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    final hostel = map['hostels'] as Map<String, dynamic>?;
    final sharing = map['sharing_types'] as Map<String, dynamic>?;

    return UserProfile(
      id: map['id'] as String,
      firstName: map['first_name'] as String? ?? '',
      lastName: map['last_name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      jobTitle: map['job_title'] as String?,
      hostelId: map['hostel_id'] as String? ?? '',
      hostelName: hostel?['name'] as String? ?? map['hostel_name'] as String? ?? '',
      hostelAddress:
          hostel?['address'] as String? ?? map['hostel_address'] as String? ?? '',
      sharingTypeId: map['sharing_type_id'] as String? ?? '',
      sharingLabel: sharing?['label'] as String? ?? map['sharing_label'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ??
          (sharing?['amount'] as num?)?.toDouble() ??
          0,
      paymentDate: map['payment_date'] as String? ?? '',
      isAdmin: map['is_admin'] as bool? ?? false,
    );
  }
}
