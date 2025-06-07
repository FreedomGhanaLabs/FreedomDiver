import 'package:flutter/material.dart';
import 'package:freedomdriver/feature/profile/view/profile_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/widgets/custom_divider.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';


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
    this.image,
    this.bottomNavigationBar,
  });

  final List<Widget> children;
  final String? title;
  final bool showDivider;
  final bool hasBackButton;
  final List<Widget>? actions;
  final String? bodyHeader;
  final String? bodyDescription;
  final ImageProvider<Object>? image;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: BoxDecoration(
          image:
              image != null
                  ? DecorationImage(
                    image: image!,
                    fit: BoxFit.fill,
                    opacity: 0.05,
                  )
                  : null,
        ),
        child: Column(
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
                  horizontal:
                      Responsive.isBigMobile(context)
                          ? whiteSpace
                          : smallWhiteSpace,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (bodyHeader != null) ...[
                      const VSpace(smallWhiteSpace),
                      Text(bodyHeader ?? '', style: normalTextStyle),
                    ],
                    if (bodyDescription != null)
                      Text(bodyDescription ?? '', style: descriptionTextStyle),
                    const VSpace(smallWhiteSpace),
                    ...children,
                    const VSpace(whiteSpace),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
