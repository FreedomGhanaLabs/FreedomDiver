import 'package:flutter/material.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';
import 'package:freedom_driver/shared/widgets/custom_overlay.dart';
import 'package:freedom_driver/shared/widgets/toaster.dart';
import 'package:loader_overlay/loader_overlay.dart';

void showLoadingOverlay(BuildContext context, [String? message]) {
  context.loaderOverlay.show(
    widgetBuilder: (_) => CustomLoader(text: message),
  );
}

void hideLoadingOverlay(
  BuildContext context, {
  String? message,
  bool canPop = true,
  bool hasToast = false,
}) {
  context.loaderOverlay.hide();
  if (canPop) {
    Navigator.of(context).pop();
  }

  if (hasToast) {
    showToast(context, 'Error', message ?? '', toastType: ToastType.error);
  }
}
