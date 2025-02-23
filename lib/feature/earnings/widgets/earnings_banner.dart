import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EarningsBanner extends StatelessWidget {
  const EarningsBanner({
    super.key,
    required this.title,
    required this.child,
    required this.subtitle,
    required this.child2,

  });
  final Widget child;
  final String title;
  final String subtitle;
  final Widget child2;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        gradient:  const LinearGradient(
          begin: Alignment(-2.6, 0.72),
          end: Alignment(0.99, 0.05),
          colors: [Color(0x00F6AE35), Color(0xF6FBDCA7), Colors.white],
          stops: [0.1, 0.58, 0.7],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.black.withOpacity(0.07999999821186066),
          ),
          borderRadius: BorderRadius.circular(13),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 13.33,
                  fontWeight: FontWeight.w400,
                )
              ),
              SizedBox(
                width: 200,
                child: Text(
                 subtitle,
                  maxLines: 2,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 10.63,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              child,
            ],
          ),
          const Spacer(),
         child2,
        ],
      ),
    );
  }
}
