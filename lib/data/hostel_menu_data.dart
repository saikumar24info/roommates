class HostelMenuData {
  static Map<String, dynamic> weeklyMenu() {
    return {
      'Monday': _mondayMeals(),
      'Tuesday': _tuesdayMeals(),
      'Wednesday': _wednesdayMeals(),
      'Thursday': _thursdayMeals(),
      'Friday': _fridayMeals(),
      'Saturday': _saturdayMeals(),
      'Sunday': _sundayMeals(),
    };
  }

  static List<Map<String, dynamic>> _mondayMeals() => [
        _meal('Morning', 'Monday',
            'https://www.indianhealthyrecipes.com/wp-content/uploads/2022/07/moong-dal-dosa-recipe.jpg',
            'Plain Dosa', 'Pappula chutney', true),
        _meal('Afternoon', 'Monday',
            'https://media.30seconds.com/tip/lg/Red-Lentil-Dal-Rice-Recipe-34072-eff47d38bc-1636485374.jpg',
            'Rice, Dal and any Curry or Fry',
            'Rice, Dal and any Curry or Fry and Mango Pickle', true),
        _meal('Night', 'Monday',
            'https://dailyreveries.com/wp-content/uploads/2023/05/16-1.jpg',
            'Rice, Sambar & any Curry', 'Rice, Sambar & any Curry', true),
      ];

  static List<Map<String, dynamic>> _tuesdayMeals() => [
        _meal('Morning', 'Tuesday',
            'https://www.vegrecipesofindia.com/wp-content/uploads/2016/04/punugulu-recipe-1-500x500.jpg',
            'Punugulu', 'Punugulu & Pappula chutney', true),
        _meal('Afternoon', 'Tuesday',
            'https://media.30seconds.com/tip/lg/Red-Lentil-Dal-Rice-Recipe-34072-eff47d38bc-1636485374.jpg',
            'Rice & Dal', 'Rice, Dal and Mango Pickle', true),
        _meal('Night', 'Tuesday',
            'https://dailyreveries.com/wp-content/uploads/2023/05/16-1.jpg',
            'Rice, Sambar & any Curry', 'Rice, Sambar & any Curry', true),
      ];

  static List<Map<String, dynamic>> _wednesdayMeals() => [
        _meal('Morning', 'Wednesday',
            'https://chakriskitchen.com/wp-content/uploads/2018/12/Idly19.jpg',
            'Idly', 'Pappula chutney or Sambar', true),
        _meal('Afternoon', 'Wednesday',
            'https://media.30seconds.com/tip/lg/Red-Lentil-Dal-Rice-Recipe-34072-eff47d38bc-1636485374.jpg',
            'Rice & Dal', 'Rice, Dal and Mango Pickle', true),
        _meal('Night', 'Wednesday',
            'https://i.pinimg.com/736x/ee/6d/c1/ee6dc1b7f73a422c199acbf67e06fc19.jpg',
            'Palav Rice & Chicken',
            'Palav Rice & Chicken or Paneer or Mushroom', false),
      ];

  static List<Map<String, dynamic>> _thursdayMeals() => [
        _meal('Morning', 'Thursday',
            'https://c8.alamy.com/comp/2CAK3DG/uthappam-oruttapamis-a-type-of-dosa-from-south-india-which-is-thicker-with-tomato-onion-and-chilli-toppings-2CAK3DG.jpg',
            'Uthappam', 'Uthappam & Pappula chutney', true),
        _meal('Afternoon', 'Thursday',
            'https://media.30seconds.com/tip/lg/Red-Lentil-Dal-Rice-Recipe-34072-eff47d38bc-1636485374.jpg',
            'Rice & Dal', 'Rice, Dal and Mango Pickle', true),
        _meal('Night', 'Thursday',
            'https://dailyreveries.com/wp-content/uploads/2023/05/16-1.jpg',
            'Rice, Sambar & any Curry', 'Rice, Sambar & any Curry', true),
      ];

  static List<Map<String, dynamic>> _fridayMeals() => [
        _meal('Morning', 'Friday',
            'https://recipesbylatha.files.wordpress.com/2008/09/mealmakercurry.jpg',
            'Chapathy or poori or Upma', 'Milli maker curry or Aloo kurma', true),
        _meal('Afternoon', 'Friday',
            'https://dailyreveries.com/wp-content/uploads/2023/05/16-1.jpg',
            'Rice, Sambar & any Curry', 'Rice, Sambar & any Curry', true),
        _meal('Night', 'Friday',
            'https://www.yummytummyaarthi.com/wp-content/uploads/2023/08/egg-fried-rice-1.jpg',
            'Fried Rice', 'Egg Fried Rice & Veg Fried Rice', false),
      ];

  static List<Map<String, dynamic>> _saturdayMeals() => [
        _meal('Morning', 'Saturday',
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFy6V_QZ0GEdXlmG8zQmSmyi7NC1WzdCy3nQ&s',
            'Upma', 'Upma & Pappula chutney', true),
        _meal('Afternoon', 'Saturday',
            'https://www.shutterstock.com/image-photo/sambar-rice-south-indian-food-260nw-1771868309.jpg',
            'Rice & Dal', 'Rice & Dal', true),
        _meal('Night', 'Saturday',
            'https://dailyreveries.com/wp-content/uploads/2023/05/16-1.jpg',
            'Rice, Sambar & any Curry', 'Rice, Sambar & any Curry', true),
      ];

  static List<Map<String, dynamic>> _sundayMeals() => [
        _meal('Morning', 'Sunday',
            'https://i.ytimg.com/vi/hDz1MzBKP4s/sddefault.jpg',
            'Pulihora', 'Pulihora & Mango Pickle', true),
        _meal('Afternoon', 'Sunday',
            'https://www.shutterstock.com/image-photo/sambar-rice-south-indian-food-260nw-1771868309.jpg',
            'Rice, Sambar & Gottalu', 'Rice, Sambar & Gottalu', true),
        _meal('Night', 'Sunday',
            'https://i.pinimg.com/736x/ee/6d/c1/ee6dc1b7f73a422c199acbf67e06fc19.jpg',
            'Palav Rice & Chicken',
            'Palav Rice & Chicken or Paneer or Mushroom', false),
      ];

  static Map<String, dynamic> _meal(
    String time,
    String weekday,
    String image,
    String title,
    String description,
    bool isVeg,
  ) {
    return {
      'time': time,
      'weekday': weekday,
      'image': image,
      'title': title,
      'description': description,
      'isVeg': isVeg,
    };
  }
}
