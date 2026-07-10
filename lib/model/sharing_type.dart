class SharingType {
  final String id;
  final String label;
  final double amount;
  final int sortOrder;

  const SharingType({
    required this.id,
    required this.label,
    required this.amount,
    required this.sortOrder,
  });

  factory SharingType.fromMap(Map<String, dynamic> map) {
    return SharingType(
      id: map['id'] as String,
      label: map['label'] as String,
      amount: (map['amount'] as num).toDouble(),
      sortOrder: map['sort_order'] as int? ?? 0,
    );
  }

  String get amountLabel => '₹${amount.toInt()}/month';
}
