import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';

void showAlertDialog(
  BuildContext context,
  String? title,
  String? message, {
  bool extraStep = false,
  Color? titleColor,
  Color? okButtonColor,
  bool hasSecondaryButton = false,
  String buttonText = 'Got it',
  DialogType dialogType = DialogType.noHeader,
  void Function()? onPressed,
}) {
  // final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  AwesomeDialog(
    useRootNavigator: true,
    context: context,
    dialogType: dialogType,
    animType: AnimType.bottomSlide,
    padding: const EdgeInsets.all(smallWhiteSpace),
    title: title,
    desc: message,
    showCloseIcon: true,
    btnOkText: buttonText,
    btnOkColor: okButtonColor ?? gradient1,
    btnCancelColor: greyColor,
    btnCancel: !hasSecondaryButton
        ? null
        : SimpleButton(
            title: 'Cancel',
            textStyle: const TextStyle(fontSize: paragraphText, color: Colors.black),
            backgroundColor:greyColor ,
            padding: const EdgeInsets.all(extraSmallWhiteSpace),
            borderRadius: BorderRadius.circular(roundedFull),
            onPressed: () => Navigator.pop(context),
          ),
    // dialogBackgroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: titleColor ?? fillColor2,
      fontWeight: FontWeight.w500,
      fontSize: headingText,
    ),
    descTextStyle: const TextStyle(
      color: Colors.black54,
    ),
    btnOkOnPress: onPressed,
  ).show();
}
