import 'package:flutter/material.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';

class DecoratedBackButton extends StatelessWidget {
  const DecoratedBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        height: 38.09,
        width: 38.09,
        decoration:
            const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        child: const Padding(
          padding: EdgeInsets.fromLTRB(8.86, 8.86, 9.74, 9.74),
          child: AppIcon(iconName: 'back_button'),
        ),
      ),
    );
  }
}
