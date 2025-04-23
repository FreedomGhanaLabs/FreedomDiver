import 'dart:developer';

import 'package:flutter/material.dart';

Future<void> handleApiCall({
  required BuildContext context,
  required Future<void> Function() apiRequest,
  void Function()? onSuccess,
  void Function()? onFailure,
  void Function(Object error)? onError,
}) async {
  try {
    await apiRequest();
    onSuccess?.call();
  } catch (e) {
    log('[Api Handler] API Error: $e');
    onError?.call(e);
    onFailure?.call();
  }
}
