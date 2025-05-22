import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Color greenColor = const Color.fromRGBO(22, 163, 74, 1);
Color greenBgColor = const Color.fromRGBO(240, 253, 244, 1);
Color redColor = const Color.fromRGBO(220, 38, 38, 1);
Color primaryColor = const Color(0xff660066); //hex code 660066
Color secondaryColor = const Color(0xfff042F0);
Color tertiaryColor = const Color.fromRGBO(255, 214, 255, 1);

List<Color> gradientColor = [const Color(0xFFF59E0B), const Color(0xffE61D2A)];

ButtonStyle elevatedButtonStyle = ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(primaryColor),
  padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
);

TextStyle headingTextStyle = TextStyle(
  fontSize: headingText.sp,
  fontWeight: FontWeight.bold,
);

TextStyle normalTextStyle = TextStyle(
  fontSize: normalText.sp,
  fontWeight: FontWeight.w600,
);

TextStyle paragraphTextStyle = const TextStyle(
  fontSize: paragraphText,
  // color: primaryColor,
);
TextStyle descriptionTextStyle = TextStyle(
  color: Colors.grey.shade500,
  fontSize: smallText.sp,
  fontWeight: FontWeight.w400,
);

String currentYear = DateTime.now().year.toString();

const brandName = 'Freedom Driver';
String copyrightText = '$brandName Mobile $currentYear';

const String mapsAPIKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');

double pixelRatio = 3;

const smallMobileWidth = 360.0;
const mobileWidth = 393.0;
const bigMobileWidth = 480.0;
const tabletWidth = 800.0;
const laptopWidth = 1200.0;

const extraSmallWhiteSpace = 5.0;
const smallWhiteSpace = 15.0;
const whiteSpace = 25.0;
const normalWhiteSpace = 45.0;
const largeWhiteSpace = 80.0;
const extraLargeWhiteSpace = 130.0;

const blurRadius = 9.0;
const spreadRadius = 2.0;
const shadowOpacity = 0.1;
const shadowOpacityMd = 0.3;
const buttonOpacity = 0.5;

const bigText = 35.0;
const emphasisText = 28.0;
const headingText = 22.0;
const normalText = 16.0;
const paragraphText = 14.0;
const smallText = 12.0;
const extraSmallText = 10.0;

const roundedSm = 6.0;
const roundedMd = 8.0;
const roundedLg = 16.0;
const roundedXl = 24.0;
const roundedFull = 100.0;

const animationDuration = 500; // milliseconds
const toastNotificationDuration = 15; // seconds
