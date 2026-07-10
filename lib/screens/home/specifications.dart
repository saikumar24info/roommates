import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/constants.dart';
import 'package:room_mates/utils/specifications_description.dart';
import 'package:room_mates/utils/text_utility.dart';
import 'package:room_mates/widgets/specification_details.dart';
import 'package:room_mates/widgets/specification_tile.dart';

import '../../utils/colors.dart';
import '../../utils/strings.dart';

class Specificatons extends StatefulWidget {
  const Specificatons({super.key});

  @override
  State<Specificatons> createState() => _SpecificatonsState();
}

class _SpecificatonsState extends State<Specificatons> {
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
              color: AppColors.white,
              size: height(context) * 30,
            )),
        title: TextUtility.headerText(
            context, Strings.specifications, AppColors.white),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: height(context) * 10,
            left: width(context) * 5,
            right: width(context) * 5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 3,
                child: Container(
                    height: height(context) * 250,
                    width: width(context) * 450,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width(context) * 10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: height(context) * 280,
                          width: width(context) * 155,
                          child: Column(
                            children: [
                              specificationTile(
                                  context, Constants.wifi, Strings.wifi),
                              specificationTile(context, Constants.foodMenu,
                                  Strings.homelyFood),
                              specificationTile(
                                  context, Constants.roWater, Strings.roWater),
                              specificationTile(
                                  context, Constants.locker, Strings.lockers),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height(context) * 280,
                          width: width(context) * 155,
                          child: Column(
                            children: [
                              specificationTile(
                                  context, Constants.ac, Strings.ac),
                              specificationTile(context, Constants.elevator,
                                  Strings.elevator),
                              specificationTile(context, Constants.hotWater,
                                  Strings.hotWater),
                              specificationTile(
                                  context, Constants.ccTV, Strings.ccTv)
                            ],
                          ),
                        )
                      ],
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width(context) * 5,
                    top: height(context) * 5,
                    right: width(context) * 5,
                    bottom: height(context) * 5),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: specifications.length,
                  itemBuilder: (context, index) {
                    return specificationDetails(
                      context,
                      specifications[index].icon,
                      specifications[index].title,
                      specifications[index].description,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
