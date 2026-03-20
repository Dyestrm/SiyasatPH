import 'package:flutter/material.dart';
import 'package:siyasat_ph/theme/colors.dart';

class ContinueButton extends StatelessWidget {
  final double opacity;
  final VoidCallback onPressed;
  const ContinueButton({
    super.key,
    required this.onPressed,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Opacity(
        opacity: opacity,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.primaryTeal,
            textStyle: TextStyle(fontSize: 16),
          ),
          child: Text('Next'),
        ),
      ),
    );
  }
}
