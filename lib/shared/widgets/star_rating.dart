import 'package:flutter/material.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';

class StarRating extends StatelessWidget {

  const StarRating({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.maxRating = 5,
    this.size = 32,
    this.filledColor,
    this.unfilledColor,
  });
  final int rating;
  final int maxRating;
  final double size;
  final ValueChanged<int> onRatingChanged;
  final Color? filledColor;
  final Color? unfilledColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final isFilled = index < rating;
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Icon(
              isFilled ? Icons.star : Icons.star_border,
              key: ValueKey<bool>(isFilled),
              size: size,
              color: isFilled
                  ? filledColor ?? thickFillColor
                  : unfilledColor ?? Colors.grey.shade300,
            ),
          ),
        );
      }),
    );
  }
}
