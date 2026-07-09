import 'package:firebase_database/firebase_database.dart';

class HostelManagement {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<void> createHostelData() async {
    final foodMenu = {
      "1": [
        {
          "time": "Morning",
          "weekday": "Monday",
          "image":
              "https://www.indianhealthyrecipes.com/wp-content/uploads/2022/07/moong-dal-dosa-recipe.jpg",
          "title": "Plain Dosa",
          "description": "Pappula chutney",
          "isVeg": true,
        },
        {
          "time": "Afternoon",
          "weekday": "Monday",
          "image":
              "https://media.30seconds.com/tip/lg/Red-Lentil-Dal-Rice-Recipe-34072-eff47d38bc-1636485374.jpg",
          "title": "Rice, Dal and any Curry or Fry",
          "description": "Rice, Dal and any Curry or Fry and Mango Pickle",
          "isVeg": true,
        },
        {
          "time": "Night",
          "weekday": "Monday",
          "image":
              "https://dailyreveries.com/wp-content/uploads/2023/05/16-1.jpg",
          "title": "Rice, Sambar & any Curry",
          "description": "Rice, Sambar & any Curry",
          "isVeg": true,
        },
      ],
      "2": [
        {
          "time": "Morning",
          "weekday": "Tuesday",
          "image":
              "https://www.vegrecipesofindia.com/wp-content/uploads/2016/04/punugulu-recipe-1-500x500.jpg",
          "title": "Punugulu",
          "description": "Punugulu & Pappula chutney",
          "isVeg": true,
        },
        {
          "time": "Afternoon",
          "weekday": "Tuesday",
          "image":
              "https://media.30seconds.com/tip/lg/Red-Lentil-Dal-Rice-Recipe-34072-eff47d38bc-1636485374.jpg",
          "title": "Rice & Dal",
          "description": "Rice, Dal and Mango Pickle",
          "isVeg": true,
        },
        {
          "time": "Night",
          "weekday": "Tuesday",
          "image":
              "https://dailyreveries.com/wp-content/uploads/2023/05/16-1.jpg",
          "title": "Rice, Sambar & any Curry",
          "description": "Rice, Sambar & any Curry",
          "isVeg": true,
        },
      ],
      "3": [
        {
          "time": "Morning",
          "weekday": "Wednesday",
          "image":
              "https://chakriskitchen.com/wp-content/uploads/2018/12/Idly19.jpg",
          "title": "Idly",
          "description": "Pappula chutney or Sambar",
          "isVeg": true,
        },
        {
          "time": "Afternoon",
          "weekday": "Wednesday",
          "image":
              "https://media.30seconds.com/tip/lg/Red-Lentil-Dal-Rice-Recipe-34072-eff47d38bc-1636485374.jpg",
          "title": "Rice & Dal",
          "description": "Rice, Dal and Mango Pickle",
          "isVeg": true,
        },
        {
          "time": "Night",
          "weekday": "Wednesday",
          "image":
              "https://i.pinimg.com/736x/ee/6d/c1/ee6dc1b7f73a422c199acbf67e06fc19.jpg",
          "title": "Palav Rice & Chicken",
          "description": "Palav Rice & Chicken or Paneer or Mushroom",
          "isVeg": false,
        },
      ],
      "4": [
        {
          "time": "Morning",
          "weekday": "Thursday",
          "image":
              "https://c8.alamy.com/comp/2CAK3DG/uthappam-oruttapamis-a-type-of-dosa-from-south-india-which-is-thicker-with-tomato-onion-and-chilli-toppings-2CAK3DG.jpg",
          "title": "Uthappam",
          "description": "Uthappam & Pappula chutney",
          "isVeg": true,
        },
        {
          "time": "Afternoon",
          "weekday": "Thursday",
          "image":
              "https://media.30seconds.com/tip/lg/Red-Lentil-Dal-Rice-Recipe-34072-eff47d38bc-1636485374.jpg",
          "title": "Rice & Dal",
          "description": "Rice, Dal and Mango Pickle",
          "isVeg": true,
        },
        {
          "time": "Night",
          "weekday": "Thursday",
          "image":
              "https://dailyreveries.com/wp-content/uploads/2023/05/16-1.jpg",
          "title": "Rice, Sambar & any Curry",
          "description": "Rice, Sambar & any Curry",
          "isVeg": true,
        },
      ],
      "5": [
        {
          "time": "Morning",
          "weekday": "Friday",
          "image":
              "https://recipesbylatha.files.wordpress.com/2008/09/mealmakercurry.jpg",
          "title": "Chapathy or poori or Upma",
          "description": "Milli maker curry or Aloo kurma",
          "isVeg": true,
        },
        {
          "time": "Afternoon",
          "weekday": "Friday",
          "image":
              "https://dailyreveries.com/wp-content/uploads/2023/05/16-1.jpg",
          "title": "Rice, Sambar & any Curry",
          "description": "Rice, Sambar & any Curry",
          "isVeg": true,
        },
        {
          "time": "Night",
          "weekday": "Friday",
          "image":
              "https://www.yummytummyaarthi.com/wp-content/uploads/2023/08/egg-fried-rice-1.jpg",
          "title": "Fried Rice",
          "description": "Egg Fired Rice & Veg Fried Rice",
          "isVeg": false,
        },
      ],
      "6": [
        {
          "time": "Morning",
          "weekday": "Saturday",
          "image":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFy6V_QZ0GEdXlmG8zQmSmyi7NC1WzdCy3nQ&s",
          "title": "Upma",
          "description": "Upma & Pappula chutney",
          "isVeg": true,
        },
        {
          "time": "Afternoon",
          "weekday": "Saturday",
          "image":
              "https://www.shutterstock.com/image-photo/sambar-rice-south-indian-food-260nw-1771868309.jpg",
          "title": "Rice & Dal",
          "description": "Rice & Dal",
          "isVeg": true,
        },
        {
          "time": "Night",
          "weekday": "Saturday",
          "image":
              "https://dailyreveries.com/wp-content/uploads/2023/05/16-1.jpg",
          "title": "Rice, Sambar & any Curry",
          "description": "Rice, Sambar & any Curry",
          "isVeg": true,
        },
      ],
      "7": [
        {
          "time": "Morning",
          "weekday": "Sunday",
          "image": "https://i.ytimg.com/vi/hDz1MzBKP4s/sddefault.jpg",
          "title": "Pulihora",
          "description": "Pulihora & Mango Pickle",
          "isVeg": true,
        },
        {
          "time": "Afternoon",
          "weekday": "Sunday",
          "image":
              "https://www.shutterstock.com/image-photo/sambar-rice-south-indian-food-260nw-1771868309.jpg",
          "title": "Rice, Sambar & Gottalu",
          "description": "Rice, Sambar & Gottalu",
          "isVeg": true,
        },
        {
          "time": "Night",
          "weekday": "Sunday",
          "image":
              "https://i.pinimg.com/736x/ee/6d/c1/ee6dc1b7f73a422c199acbf67e06fc19.jpg",
          "title": "Palav Rice & Chicken",
          "description": "Palav Rice & Chicken or Paneer or Mushroom",
          "isVeg": false,
        },
      ],
    };

    // final stayInfo = {
    //   "roomNo": "301",
    //   "payingDate": "6 th of Month",
    //   "type": "3 Share",
    //   "fee": "5500/- Monthly",
    //   "address": "LIG: 333, RoadNo: 3, KPHB colony, Kukatpally",
    // };

    await _db
        .child('Hyderabad/KPHB/Manikanta Boys Hostel/foodMenu')
        .set(foodMenu);
  }

  Future registerUser({
    required String name,
    required int roomNo,
    required String joiningDate,
    required String roomType,
    required double amount,
    required String hostelName,
    required String hostelAddress,
    required String phoneNumber,
  }) async {
    DatabaseReference userRef =
        _db.child('Hyderabad/KPHB/$hostelName/MyStay').push();

    final userData = {
      "fullName": name,
      "roomNumber": roomNo,
      "joiningDate": joiningDate,
      "roomType": roomType,
      "amount": amount,
      "hostelName": hostelName,
      "hostelAddress": hostelAddress,
      "phoneNumber": phoneNumber,
    };
    await userRef.set(userData);
    return userRef;
  }
}
