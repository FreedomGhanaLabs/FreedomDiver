import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScoreGauge extends StatelessWidget {
  final double score;
  final double maxScore;
  final List<Color> gradientColors;
  final List<double>? stops;
  final Color backgroundColor;

  const ScoreGauge({
    Key? key,
    required this.score,
    this.maxScore = 100,
    this.gradientColors = const [Colors.blue, Colors.purple],
    this.stops,
    this.backgroundColor = Colors.grey,
  })  : assert(gradientColors.length >= 2,
            'Must provide at least 2 colors for gradient'),
        assert(stops == null || stops.length == gradientColors.length,
            'If stops are provided, they must match the number of colors'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: const Size(428, 926),
            painter: _GaugePainter(
              score: score,
              maxScore: maxScore,
              gradientColors: gradientColors,
              stops: stops,
              backgroundColor: backgroundColor,
            ),
          ),
          Positioned(
              bottom: -30,

              child: Container(
            // height: 76,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: OvalBorder(
                side: BorderSide(
                  color: Colors.black.withOpacity(0.07999999821186066),
                ),
              ),
            ),
                child: Center(
                  child: Text(
                    score.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 27.52,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
          ),),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double score;
  final double maxScore;
  final List<Color> gradientColors;
  final List<double>? stops;
  final Color backgroundColor;

  _GaugePainter({
    required this.score,
    required this.maxScore,
    required this.gradientColors,
    required this.backgroundColor,
    this.stops,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width * 0.3;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Draw the background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;
    canvas.drawArc(
      rect,
      pi,
      pi,
      false,
      backgroundPaint,
    );

    // Create gradient for progress arc using LinearGradient instead of SweepGradient
    final gradientPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 30
      ..shader = LinearGradient(
        colors: gradientColors,
        stops: stops,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height - radius),
        radius: radius,
      ));

    // Draw the progress arc
    canvas.drawArc(
      rect,
      pi,
      (score / maxScore) * pi,
      false,
      gradientPaint,
    );

    // Draw the markings
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw markings at intervals
    for (int i = 0; i <= maxScore; i += 20) {
      final angle = pi + (i / maxScore) * pi;
      final markerStart = Offset(
        center.dx + (radius - 25) * cos(angle),
        center.dy + (radius - 25) * sin(angle),
      );
      final markerEnd = Offset(
        center.dx + (radius + 5) * cos(angle),
        center.dy + (radius + 5) * sin(angle),
      );

      // canvas.drawLine(
      //   markerStart,
      //   markerEnd,
      //   Paint()
      //     ..color = Colors.grey
      //     ..strokeWidth = 2,
      // );

      // Draw the number
      textPainter.text = TextSpan(
        text: i.toString(),
        style: GoogleFonts.poppins(
          color: Color(0xFFC2C2C2),
          fontSize: 15,
          fontWeight: FontWeight.w300,
        ),
      );
      textPainter.layout();

      final textOffset = Offset(
        center.dx + (radius + 25) * cos(angle) - textPainter.width / 5,
        center.dy + (radius + 25) * sin(angle) - textPainter.height,
      );
      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
