import 'package:flutter/material.dart';
import 'package:genova/core/app_config.dart';
import 'package:provider/provider.dart';

import '../core/context/theme_context.dart';

class CustomLoader extends StatefulWidget {
  final String text;
  const CustomLoader(
      {super.key, this.text = "Please hold on, we are working on it"});

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: Durations.extralong4,
  )..repeat();

  final Tween<double> defTurns = Tween<double>(begin: 0, end: 1);

  String text = "";

  @override
  void initState() {
    Future.delayed(Durations.long4, () {
      if (mounted) {
        setState(() {
          text = widget.text;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Provider.of<ThemeContext>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(whiteSpace),
            margin: const EdgeInsets.only(bottom: smallWhiteSpace),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(roundedLg),
              border: Border.all(
                color: primaryColor.withValues(alpha: shadowOpacity),
              ),
              color: Colors.white,
            ),
            child: RotationTransition(
              turns: defTurns.animate(controller),
              child: SizedBox(
                height: 50,
                width: 50,
                child: Image.asset("assets/icons/spinner.png"),
              ),
            ),
          ),
          Text(
            text,
            style: paragraphTextStyle.copyWith(
              color: themeContext.themeMode == ThemeMode.dark
                  ? Colors.white
                  : darkPurple,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
