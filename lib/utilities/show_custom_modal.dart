import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../shared/app_config.dart';

AwesomeDialog showCustomModal(
  BuildContext context, {
  Widget? child,
  EdgeInsetsGeometry? padding,
  void Function()? btnOkOnPress,
  void Function()? btnCancelOnPress,
  String? btnOkText,
  String btnCancelText = 'Cancel',
  DialogType dialogType = DialogType.noHeader,
  AnimType animType = AnimType.scale,
  Color? dialogBackgroundColor,
}) {
  return AwesomeDialog(
    context: context,
    dialogType: dialogType,
    dialogBackgroundColor: dialogBackgroundColor ?? Colors.white,
    animType: animType,
    padding:
        padding ??
        const EdgeInsets.only(
          top: smallWhiteSpace,
          left: smallWhiteSpace,
          right: smallWhiteSpace,
        ),
    body: child,
    btnOkColor: Colors.black,
    autoHide: Duration(minutes: 30),
    // autoDismiss: false,
    // onDismissCallback: (type) {
    //   if (type == DismissType.btnOk) return;
    //   Navigator.of(context).pop();
    // },
    btnOkText: btnOkText,
    btnCancelText: btnCancelText,
    btnOkOnPress: btnOkOnPress,
    btnCancelOnPress: btnCancelOnPress,
  );
}
