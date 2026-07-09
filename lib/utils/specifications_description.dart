import '../model/specifications_model.dart';

final List<Map<String, dynamic>> jsonData = [
  {
    "id": 1,
    "title": "Wifi",
    "description":
        "Enjoy fast and reliable 24/7 wifi access in every room, ensuring you stay connected at all times.",
    "icon": "assets/icons/wifi_signal.png"
  },
  {
    "id": 2,
    "title": "Ac Rooms",
    "description":
        "Experience comfort in our air-conditioned rooms, providing a cool and pleasant environment.",
    "icon": "assets/icons/ac.png"
  },
  {
    "id": 3,
    "title": "Homely Food",
    "description":
        "Our meals will remind you of home. You can also cook for yourself or place orders as needed.",
    "icon": "assets/icons/food_menu.png"
  },
  {
    "id": 4,
    "title": "Elevator",
    "description":
        "Our building features an elevator for convenient access from the ground floor to the top floor at any time.",
    "icon": "assets/icons/elevator.png"
  },
  {
    "id": 5,
    "title": "RO Water",
    "description":
        "Stay hydrated with clean, chilled RO water available on every floor.",
    "icon": "assets/icons/drop.png"
  },
  {
    "id": 6,
    "title": "Hot Water",
    "description":
        "Enjoy 24/7 hot water availability on every floor for your convenience.",
    "icon": "assets/icons/water_heater.png"
  },
  {
    "id": 7,
    "title": "Lockers",
    "description":
        "Your safety is our priority. Each room is equipped with individual lockers for secure storage.",
    "icon": "assets/icons/locker.png"
  },
  {
    "id": 8,
    "title": "CCTV",
    "description":
        "Our building is under continuous CCTV surveillance for enhanced security.",
    "icon": "assets/icons/cctv.png"
  }
];

final List<Specifications> specifications =
    jsonData.map((item) => Specifications.fromJson(item)).toList();
