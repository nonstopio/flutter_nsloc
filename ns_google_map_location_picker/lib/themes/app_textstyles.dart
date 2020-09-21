import 'package:flutter/material.dart';
import 'package:ns_google_map_location_picker/utils/sizes.dart';

import 'app_colors.dart';

class FontFamily {
  static const String PoppinsBold = "Poppins-Bold";
  static const String PoppinsMedium = "Poppins-Medium";
  static const String PoppinsRegular = "Poppins-Regular";
}

class TextStyles {
  static const TextDecoration underline = TextDecoration.underline;
  static const TextDecoration lineThrough = TextDecoration.lineThrough;

  static TextStyle get defaultRegular => TextStyle(
        fontFamily: FontFamily.PoppinsRegular,
        fontSize: FontSize.s16,
        color: Colors.black,
        inherit: false,
      );

  static TextStyle get defaultBold => TextStyle(
        fontFamily: FontFamily.PoppinsBold,
        fontWeight: FontWeight.bold,
        fontSize: FontSize.s16,
        color: Colors.black,
        inherit: false,
      );

  static TextStyle get defaultMedium => TextStyle(
        fontFamily: FontFamily.PoppinsMedium,
        fontSize: FontSize.s16,
        color: Colors.black,
        inherit: false,
      );

  static TextStyle get alertText => TextStyle(
        fontFamily: FontFamily.PoppinsRegular,
        fontSize: FontSize.s16,
        color: Colors.black,
        inherit: false,
      );

  static TextStyle get alertTitle => TextStyle(
        fontFamily: FontFamily.PoppinsRegular,
        fontSize: FontSize.s22,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.60,
        inherit: false,
      );

  static TextStyle get snackBarText => TextStyle(
        fontFamily: FontFamily.PoppinsRegular,
        fontSize: FontSize.s15,
        color: Colors.white,
        letterSpacing: 1.4,
        inherit: false,
      );

  static TextStyle get editText => TextStyle(
        fontFamily: FontFamily.PoppinsMedium,
        fontWeight: FontWeight.bold,
        fontSize: FontSize.s17,
        color: Colors.black,
        inherit: false,
        textBaseline: TextBaseline.alphabetic,
      );

  static TextStyle get valueText => TextStyle(
        fontFamily: FontFamily.PoppinsMedium,
        fontWeight: FontWeight.bold,
        fontSize: FontSize.s16,
        color: Colors.black,
        inherit: false,
        textBaseline: TextBaseline.alphabetic,
      );

  static TextStyle get labelStyle => TextStyle(
        fontFamily: FontFamily.PoppinsMedium,
        fontSize: FontSize.s14,
        color: Colors.grey.shade600,
        inherit: false,
      );

  static TextStyle get hintStyle => TextStyle(
        fontFamily: FontFamily.PoppinsRegular,
        fontSize: FontSize.s14,
        color: Colors.grey.shade600,
        inherit: false,
      );

  static TextStyle get errorStyle => TextStyle(
        fontFamily: FontFamily.PoppinsRegular,
        fontSize: FontSize.s13,
        color: AppColors.primaryColor,
        inherit: false,
      );

  static TextStyle get buttonText => TextStyle(
        fontFamily: FontFamily.PoppinsRegular,
        fontSize: FontSize.s18,
        color: Colors.white,
        letterSpacing: 0.13,
        inherit: false,
      );
}
