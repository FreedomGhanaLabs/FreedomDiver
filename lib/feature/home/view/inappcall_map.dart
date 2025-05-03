import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_driver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedom_driver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/app_icon.dart';
import 'package:freedom_driver/shared/widgets/custom_divider.dart';
import 'package:freedom_driver/shared/widgets/custom_drop_down_button.dart';
import 'package:freedom_driver/utilities/responsive.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class InAppCallMap extends StatefulWidget {
  const InAppCallMap({super.key});
  static const String routeName = '/inAppCallMap';

  @override
  State<InAppCallMap> createState() => _InAppCallMapState();
}

class _InAppCallMapState extends State<InAppCallMap> {
  static LatLng sanFrancisco = const LatLng(37.774546, -122.433523);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: sanFrancisco,
              zoom: 13,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 25,
            child: const DecoratedBackButton(),
          ),
          CustomBottomSheet(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VSpace(41),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 41,
                        height: 41,
                        decoration: const ShapeDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/app_images/client_holder_image.png',
                            ),
                            fit: BoxFit.fill,
                          ),
                          shape: OvalBorder(),
                        ),
                      ),
                      const HSpace(18),
                      const Text(
                        'Dr Ben Larry Cage',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.99,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const TypeCapsule(),
                    ],
                  ),
                ),
                const VSpace(21),
                Container(
                  width: 424,
                  height: 2,
                  decoration: const BoxDecoration(color: Color(0x72D9D9D9)),
                ),
                const VSpace(14),
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Text(
                    'A passenger is waiting for you',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: smallText.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const VSpace(19),
                // EqualSignCrossContainer(),
                const Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        PassengerDestinationDetailBox(),
                        VSpace(38),
                        PassengerDestinationDetailBox(),
                      ],
                    ),
                    AppIcon(iconName: 'conversion'),
                  ],
                ),
                const VSpace(whiteSpace),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Price',
                          style: TextStyle(
                            color: Colors.black
                                .withValues(alpha: 0.5600000023841858),
                            fontSize: 9.15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const VSpace(10),
                        const Text(
                          r'$20.5',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.72,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'EXpected Distance  Covered',
                          style: TextStyle(
                            color: Colors.black
                                .withValues(alpha: 0.5600000023841858),
                            fontSize: 9.15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const VSpace(10),
                        const Text(
                          '40.5KM',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.72,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Avg.TIme',
                          style: TextStyle(
                            color: Colors.black
                                .withValues(alpha: 0.5600000023841858),
                            fontSize: 9.15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const VSpace(10),
                        const Text(
                          '30:00PM',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.72,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const VSpace(37),
                Padding(
                  padding: const EdgeInsets.only(left: 23),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomDropDown(
                        items: const <String>['In-App Call', 'Video Call'],
                        initialValue: 'In-App Call',
                        onChanged: (i) {},
                      ),
                      const HSpace(30),
                      Container(
                        margin: const EdgeInsets.only(right: 25),
                        alignment: Alignment.center,
                        width: 139,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: GradientBoxBorder(gradient: gradient),
                        ),
                        child: ShaderMask(
                          shaderCallback: (bounds) => gradient.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          child: const Text(
                            'Message',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.99,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const VSpace(18),
                const CustomDivider(),
                const VSpace(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23),
                  child: SizedBox(
                    width: double.infinity,
                    child: SimpleButton(
                      title: '',
                      onPressed: () {},
                      borderRadius: BorderRadius.circular(5),
                      padding: const EdgeInsets.fromLTRB(0, 13, 0, 13),
                      backgroundColor: const Color(0xFFD47F00),
                      child: const Text(
                        'Waiting',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.99,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const VSpace(20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PassengerDestinationDetailBox extends StatelessWidget {
  const PassengerDestinationDetailBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 23),
      child: Container(
        width: 369,
        padding: const EdgeInsets.only(left: 8, top: 13, bottom: 12.96),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0x19110F51)),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pickup Point',
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.5099999904632568),
                fontSize: 7.90,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Text(
              '23,Canada ,avenue',
              style: TextStyle(
                color: Colors.black,
                fontSize: 9.17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    required this.child,
    this.height,
    super.key,
    this.padding,
  });
  final double? height;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: padding,
          curve: Curves.easeInOut,
          height: height,
          width: Responsive.width(context),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: SingleChildScrollView(child: child),
        ),
      ),
    );
  }
}

class TypeCapsule extends StatelessWidget {
  const TypeCapsule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black.withValues(alpha: 0.1),
          ),
          borderRadius: BorderRadius.circular(roundedMd),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Logistics',
            style: TextStyle(
              color: gradient1,
              fontSize: smallText.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
