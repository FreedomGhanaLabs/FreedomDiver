import 'package:flutter/material.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverTotalOrder extends StatelessWidget {
  const DriverTotalOrder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 17, top: 9, bottom: 13, right: 34),
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black.withValues(alpha: 0.119),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Total Order',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18.66,
            fontWeight: FontWeight.w400,
          ),
        ),
        const VSpace(5),
        Text(
          '20',
          style: GoogleFonts.poppins(
            color: const Color(0xFFF59E0B),
            fontSize: 16.82,
            fontWeight: FontWeight.w600,
            height: 1.29,
            letterSpacing: -0.40,
          ),
        )
      ]),
    );
  }
}
