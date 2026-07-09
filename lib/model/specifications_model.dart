class Specifications {
  final int id;
  final String title;
  final String description;
  final String icon;

  Specifications({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  factory Specifications.fromJson(Map<String, dynamic> json) {
    return Specifications(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}
