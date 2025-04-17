import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedom_driver/feature/authentication/register/register.dart';
import 'package:freedom_driver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});
  static const routeName = 'profileDetails';

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Padding(
                    padding: EdgeInsets.only(left: 27),
                    child: DecoratedBackButton()),
                const HSpace(84.91),
                Center(
                  child: Text(
                    'Profile Details',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 13.09,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
            const VSpace(14.91),
            Container(
              height: 8,
              color: greyColor,
            ),
            const VSpace(8),
            Padding(
              padding: const EdgeInsets.only(left: 27, right: 19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Full Name',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 13.09,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const VSpace(10),
                  TextFieldFactory.name(
                    controller: nameController,
                    fillColor: Colors.white,
                    enabledColorBorder: const Color(0xFFE1E1E1),
                    hinText: 'Full Name',
                    focusedBorderColor: Colors.black,
                    // enabledBorderRadius:
                    //     const BorderRadius.all(Radius.circular(10)),
                    hintTextStyle: GoogleFonts.poppins(
                        color: hintTextColor, fontSize: 11.50),
                  ),
                  const VSpace(20),
                  Row(
                    children: [
                      Text(
                        'Email',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 13.09,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const HSpace(10),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 9,
                          bottom: 9,
                          left: 10,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffBFFF9F),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Verified',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 11.9, color: const Color(0xff52C01B)),
                        ),
                      ),
                    ],
                  ),
                  const VSpace(10),
                  TextFieldFactory.email(
                    controller: emailController,
                    fillColor: Colors.white,
                    hinText: 'youremail@email.com',
                    focusedBorderColor: Colors.black,
                    enabledColorBorder: const Color(0xFFE1E1E1),
                    // enabledBorderRadius:
                    //     const BorderRadius.all(Radius.circular(10)),
                    hintTextStyle: GoogleFonts.poppins(),
                  ),
                  const VSpace(10),
                  Row(
                    children: [
                      Text(
                        'Phone Number',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 13.09,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const HSpace(10),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 9,
                          bottom: 9,
                          left: 10,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffBFFF9F),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Verified',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 11.9, color: const Color(0xff52C01B)),
                        ),
                      ),
                    ],
                  ),
                  const VSpace(10),
                  TextFieldFactory.phone(
                    controller: emailController,
                    fillColor: Colors.white,
                    hintText: '+244-902-345-909',
                    fontStyle: GoogleFonts.poppins(),
                    focusedBorderColor: Colors.black,
                    enabledColorBorder: const Color(0xFFE1E1E1),
                    suffixIcon: Container(
                      margin: const EdgeInsets.only(
                        right: 10,
                        top: 5,
                        bottom: 5,
                      ),
                      padding: EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.edit, color: Colors.white),
                          Text('Change Number',
                              style: GoogleFonts.poppins(color: Colors.white))
                        ],
                      ),
                    ),
                    prefixText: Container(
                      height: 20,
                      width: 20,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(
                        left: 10,
                        top: 9,
                        bottom: 9,
                        right: 10,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color(0xffFFF7BC),
                      ),
                      child:
                      SvgPicture.asset('assets/app_icons/phone_numbers.svg'),
                    ),
                    hintTextStyle: GoogleFonts.poppins(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
