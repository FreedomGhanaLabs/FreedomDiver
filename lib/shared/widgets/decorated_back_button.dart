import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DecoratedBackButton extends StatelessWidget {
  const DecoratedBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 38.09,
        width: 38.09,
        decoration:
            const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.86, 8.86, 9.74, 9.74),
          child: SvgPicture.asset('assets/images/back_button.svg'),
        ),
      ),
      onTap: () => Navigator.pop(context),
    );
  }
}
