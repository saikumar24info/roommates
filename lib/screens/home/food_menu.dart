import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../global.dart';
import '../../model/menu_items_model.dart';
import '../../utils/colors.dart';
import '../../utils/food_menu_card.dart';
import '../../utils/strings.dart';
import '../../utils/text_utility.dart';

class FoodMenu extends StatefulWidget {
  const FoodMenu({super.key});

  @override
  State<FoodMenu> createState() => _FoodMenuState();
}

class _FoodMenuState extends State<FoodMenu> {
  final DatabaseReference _database = FirebaseDatabase.instance
      .ref('Hyderabad/KPHB/Manikanta Boys Hostel/foodMenu');

  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  final List<String> timeOrder = ['Morning', 'Afternoon', 'Night'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            size: height(context) * 30,
          ),
        ),
        title:
            TextUtility.headerText(context, Strings.foodMenu, AppColors.white),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _database.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitWave(
                  color: AppColors.primary, type: SpinKitWaveType.start),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.snapshot.exists) {
            return const Center(child: Text(Strings.noData));
          }

          final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<Map<String, dynamic>> sortedMenu = [];
          for (var day in daysOfWeek) {
            if (data.containsKey(day)) {
              List<dynamic> meals = data[day];
              meals.sort((a, b) => timeOrder
                  .indexOf(a['time'])
                  .compareTo(timeOrder.indexOf(b['time'])));
              sortedMenu.add({
                'day': day,
                'meals':
                    meals.map((meal) => MenuItemData.fromMap(meal)).toList(),
              });
            }
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: height(context) * 10,
                bottom: 4,
                left: width(context) * 5,
                right: width(context) * 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedMenu.length,
                    itemBuilder: (context, dayIndex) {
                      final dayMenu = sortedMenu[dayIndex];
                      // final day = dayMenu['day'];
                      final meals = dayMenu['meals'] as List<MenuItemData>;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height(context) * 2),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: meals.length,
                            itemBuilder: (context, mealIndex) {
                              final meal = meals[mealIndex];
                              return foodMenuCard(
                                context,
                                meal.weekday,
                                meal.time,
                                meal.image,
                                meal.title,
                                meal.description,
                                meal.isVeg,
                                mealIndex,
                              );
                            },
                          ),
                          SizedBox(height: height(context) * 5),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
