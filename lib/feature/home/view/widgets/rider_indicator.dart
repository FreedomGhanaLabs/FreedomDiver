import 'package:flutter/material.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';

class RiderProgressTracker extends StatefulWidget {
  const RiderProgressTracker({
    Key? key,
    this.totalMinutes = 30,
    this.currentMinutes = 10,
    this.startLocation = "Pickup Point",
    this.endLocation = "Destination",
  }) : super(key: key);
  final int totalMinutes;
  final int currentMinutes;
  final String startLocation;
  final String endLocation;

  @override
  State<RiderProgressTracker> createState() => _RiderProgressTrackerState();
}

class _RiderProgressTrackerState extends State<RiderProgressTracker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _updateProgress();
  }

  @override
  void didUpdateWidget(RiderProgressTracker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentMinutes != widget.currentMinutes) {
      _updateProgress();
    }
  }

  void _updateProgress() {
    final progress = widget.currentMinutes / widget.totalMinutes;
    _progressAnimation = Tween<double>(
      begin: _controller.value,
      end: 1.0 - progress,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 8,
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => gradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ),
        );
      },
    );
  }
}
