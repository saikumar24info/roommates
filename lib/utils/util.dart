import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:room_mates/utils/colors.dart';

class Utils {
  void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: SpinKitWave(
              color: AppColors.primary, type: SpinKitWaveType.start),
        );
      },
    );
  }

  void dismiss(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop("");
  }
}
