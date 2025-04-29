import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/profile/view/profile_screen.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/widgets/custom_divider.dart';
import 'package:freedom_driver/utilities/responsive.dart';
import 'package:freedom_driver/utilities/ui.dart';

class CustomScreen extends StatelessWidget {
  const CustomScreen({
    super.key,
    this.children = const <Widget>[],
    this.title,
    this.hasBackButton = true,
    this.actions,
  });

  final List<Widget> children;
  final String? title;
  final bool hasBackButton;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: title),
          const VSpace(smallWhiteSpace),
          const CustomDivider(height: 6),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.isBigMobile(context)
                    ? whiteSpace
                    : smallWhiteSpace,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [const VSpace(smallWhiteSpace), ...children],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
