import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';

import '../utils/colors.dart';

// ignore: must_be_immutable
class TextInput extends StatefulWidget {
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController controller;
  Widget preficIcon;
  Widget suffixIcon;
  bool obsecureText;
  TextInput({
    Key? key,
    required this.hintText,
    required this.textInputType,
    this.obsecureText = false,
    required this.controller,
    this.preficIcon = const SizedBox(),
    this.suffixIcon = const SizedBox(),
  }) : super(key: key);

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.textInputType,
      obscureText: widget.obsecureText,
      textAlign: TextAlign.start,
      obscuringCharacter: '*',
      cursorColor: AppColors.primary,
      cursorHeight: height(context) * 18,
      style: TextStyle(
        fontSize: fontSize(context) * 16,
        color: AppColors.headerText,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.preficIcon,
        prefixIconColor: AppColors.primary,
        hintStyle: TextStyle(
          fontSize: fontSize(context) * 16,
          color: AppColors.bodyText,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: EdgeInsetsDirectional.symmetric(
            vertical: height(context) * 20, horizontal: width(context) * 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width(context) * 8),
          borderSide: const BorderSide(
            color: AppColors.primary,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width(context) * 10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width(context) * 10),
          borderSide: const BorderSide(
            color: AppColors.green,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.background,
          ),
        ),
      ),
    );
  }
}
