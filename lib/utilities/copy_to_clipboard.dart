import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freedomdriver/shared/api/api_controller.dart';
import 'package:freedomdriver/shared/widgets/toaster.dart';

void copyTextToClipboard(
  BuildContext context,
  String text, {
  VoidCallback? callback,
  String? copyText,
}) {
  Clipboard.setData(ClipboardData(text: text)).then((_) {
    if (callback != null) callback();
    showToast(
      context,
      'Copied',
      '${copyText ?? text} copied to clipboard',
      toastType: ToastType.success,
    );
  }).catchError((error) {
    debugPrint('$error');
    showToast(
      context,
      'Clipboard',
      'Failed to copy ${copyText ?? text}',
      isSnackBar: true,
       contentType: ContentType.failure,
    );
  });
}
