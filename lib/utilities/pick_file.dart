import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/core/constants/documents.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';

import 'package:freedomdriver/feature/documents/cubit/document_image.dart';

void pickFile(
  BuildContext context, {
  String? title,
  String? description,
  String? type,
}) {
  final driverImageCubit = context.read<DriverImageCubit>();
  showCupertinoModalPopup(
    useRootNavigator: false,
    context: context,
    builder:
        (context) => CupertinoActionSheet(
          title:
              title != null
                  ? Text(
                    title,
                    style: normalTextStyle.copyWith(color: Colors.black),
                  )
                  : null,
          message:
              description != null
                  ? Text(description, style: paragraphTextStyle)
                  : null,
          actions: [
            CupertinoActionSheetAction(
              child: Text('Use Camera', style: TextStyle(color: gradient1)),
              onPressed: () {
                if (type != profileImage) Navigator.of(context).pop();
                driverImageCubit.pickImage(context, type: type);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                'Choose from Gallery',
                style: TextStyle(color: gradient1),
              ),
              onPressed: () {
                if (type != profileImage) Navigator.of(context).pop();
                driverImageCubit.pickImage(context, gallery: true, type: type);
              },
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: const Text(
                'Close',
                style: TextStyle(fontSize: paragraphText),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
  );
}
