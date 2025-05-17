import 'package:flutter/material.dart';
import 'package:freedomdriver/shared/widgets/custom_overlay.dart';
import 'package:loader_overlay/loader_overlay.dart';

void showLoadingOverlay(
  BuildContext context, {
  String? message,
  bool? showOverlay,
}) {
  context.loaderOverlay.show(
    showOverlay: showOverlay ?? true,
    widgetBuilder: (_) => CustomLoader(text: message),
  );
}

void hideLoadingOverlay(BuildContext context) {
  context.loaderOverlay.hide();
}
