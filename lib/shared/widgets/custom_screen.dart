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
    this.bodyHeader,
    this.bodyDescription,
    this.showDivider = true,
  });

  final List<Widget> children;
  final String? title;
  final bool showDivider;
  final bool hasBackButton;
  final List<Widget>? actions;
  final String? bodyHeader;
  final String? bodyDescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: title,
            hasBackButton: hasBackButton,
            actions: actions,
          ),
          const VSpace(extraSmallWhiteSpace),
          if (showDivider) const CustomDivider(height: 6),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.isBigMobile(context)
                    ? whiteSpace
                    : smallWhiteSpace,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (bodyHeader != null) ...[
                    const VSpace(smallWhiteSpace),
                    Text(
                      bodyHeader ?? '',
                      style: normalTextStyle,
                    ),
                  ],
                  if (bodyDescription != null)
                    Text(
                      bodyDescription ?? '',
                      style: descriptionTextStyle,
                    ),
                  const VSpace(smallWhiteSpace),
                  ...children,
                  const VSpace(whiteSpace),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
