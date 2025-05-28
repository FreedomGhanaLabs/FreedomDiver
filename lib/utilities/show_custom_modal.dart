import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../shared/app_config.dart';

AwesomeDialog showCustomModal(
  BuildContext context, {
  Widget? child,
  void Function()? btnOkOnPress,
  void Function()? btnCancelOnPress,
  String? btnOkText,
  String btnCancelText = 'Cancel',
  DialogType dialogType = DialogType.noHeader,
  AnimType animType = AnimType.topSlide,
  Color? dialogBackgroundColor,
}) {
  return AwesomeDialog(
    context: context,
    dialogType: dialogType,
    dialogBackgroundColor: dialogBackgroundColor ?? Colors.white,
    animType: animType,
    body: Padding(
      padding: const EdgeInsets.only(
        top: smallWhiteSpace,
        left: smallWhiteSpace,
        right: smallWhiteSpace,
      ),
      child: child,
    ),
    btnOkColor: Colors.black,
    autoHide: Duration(minutes: 10),
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
