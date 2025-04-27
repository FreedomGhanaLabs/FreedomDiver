import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/home/view/inappcall_map.dart';

Future<void> showCustomBottomSheet(BuildContext context, Widget child) async {
  await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return CustomBottomSheet(child: child);
      },);
}
