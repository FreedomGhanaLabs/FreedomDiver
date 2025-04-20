import 'package:flutter/widgets.dart';

Map<String, dynamic> getRouteParams(BuildContext context) {
  final args =
      (ModalRoute.of(context)!.settings.arguments ?? {'': ''})
      as Map<String, dynamic>;

  return args;
}
