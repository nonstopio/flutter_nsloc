import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nsio_flutter/themes/app_colors.dart';
import 'package:nsio_flutter/themes/app_textstyles.dart';
import 'package:nsio_flutter/utils/sizes.dart';

/// custom button widgets
///

class AppButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String title;

  final Color color;
  final bool enabled;
  final bool boxShadow;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final TextStyle style;
  final TextAlign textAlign;

  AppButton({
    @required this.onTap,
    @required this.title,
    this.enabled = true,
    this.boxShadow = false,
    this.color,
    this.padding,
    this.margin,
    this.textAlign,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : () {},
      child: Container(
        padding: padding ?? EdgeInsets.symmetric(horizontal: Sizes.s25, vertical: Sizes.s15),
        margin: margin ?? EdgeInsets.zero,
        child: Text(
          title,
          style: style ?? TextStyles.buttonText,
          textAlign: textAlign ?? TextAlign.center,
        ),
        decoration: BoxDecoration(
            color: enabled ? (color ?? AppColors.primaryColor) : AppColors.primaryColor,
            boxShadow: boxShadow
                ? [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: Sizes.s20,
                    ),
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: Sizes.s20,
                    ),
                  ]
                : []),
      ),
    );
  }
}
