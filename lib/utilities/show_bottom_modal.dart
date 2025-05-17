import 'package:flutter/material.dart';
import 'package:freedomdriver/feature/home/view/inappcall_map.dart';

Future<void> showCustomBottomSheet(BuildContext context, Widget child) async {
  showBottomSheet(
      context: context,
    backgroundColor: Colors.black12,
    showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
      return Stack(
        children: [
          CustomBottomSheet(child: child),
        ],
      );
      },);
}
