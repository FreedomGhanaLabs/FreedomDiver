import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/home/view/widgets/rider_indicator.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class EstimatedReachTime extends StatefulWidget {
  const EstimatedReachTime({super.key});

  @override
  State<EstimatedReachTime> createState() => _EstimatedReachTimeState();
}

class _EstimatedReachTimeState extends State<EstimatedReachTime> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => gradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: Text(
                '8',
                style: GoogleFonts.poppins(
                    fontSize: 30, fontWeight: FontWeight.w500),
              ),
            ),
            const HSpace(3.1),
            Text(
              'mins',
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const HSpace(13.5),
            Text(
              'until you get to your Destination',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: const Color(0xFFB3B3B3),
                fontSize: 8.39,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
        const RiderProgressTracker(
          currentMinutes: 0,
          totalMinutes: 8,
        )
      ],
    );
  }
}
