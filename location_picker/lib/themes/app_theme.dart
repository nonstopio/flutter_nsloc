library theme;

import 'package:flutter/material.dart';
import 'package:nsio_flutter/themes/app_colors.dart';

import 'app_textstyles.dart';

export '../utils/assets.dart';
export 'app_colors.dart';
export 'app_textstyles.dart';

ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.red,
  primaryColor: AppColors.primaryColor,
  fontFamily: FontFamily.PoppinsRegular,
);
