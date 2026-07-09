class MenuItemData {
  final String time;
  final String weekday;
  final String image;
  final String title;
  final String description;
  final bool isVeg;

  MenuItemData({
    required this.time,
    required this.weekday,
    required this.image,
    required this.title,
    required this.description,
    required this.isVeg,
  });

  factory MenuItemData.fromMap(Map<dynamic, dynamic> data) {
    return MenuItemData(
      time: data['time'],
      weekday: data['weekday'],
      image: data['image'],
      title: data['title'],
      description: data['description'],
      isVeg: data['isVeg'],
    );
  }
}
