import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';

Widget specificationDetails(
    BuildContext context, String icon, String title, String description) {
  return Card(
    elevation: 2,
    child: Container(
      padding: EdgeInsets.symmetric(
          horizontal: width(context) * 12, vertical: height(context) * 12),
      child: Row(
        children: [
          SizedBox(
            height: height(context) * 28,
            width: width(context) * 28,
            child: Image.asset(
              icon,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: width(context) * 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$title:',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: width(context) * 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: height(context) * 5),
                Text(
                  description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: width(context) * 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
