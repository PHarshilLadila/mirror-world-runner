// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final IconData icon;
  final Color color;
  final bool isDisabled;
  final ValueChanged<double> onChanged;

  const CustomSlider({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.icon,
    required this.color,
    required this.isDisabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            thumbShape: CustomThumbShape(),
            overlayColor: color.withOpacity(0.2),
            activeTrackColor: color,
            inactiveTrackColor: Colors.white24,
            thumbColor: color,
            disabledActiveTrackColor: Colors.grey.shade700,
            disabledInactiveTrackColor: Colors.grey.shade800,
            disabledThumbColor: Colors.grey.shade600,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            label: value.toStringAsFixed(1),
            onChanged: isDisabled ? null : onChanged,
          ),
        ),
      ],
    );
  }
}

class CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(18, 18);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Paint paint =
        Paint()
          ..shader = RadialGradient(
            colors: [sliderTheme.thumbColor!, Colors.white],
          ).createShader(Rect.fromCircle(center: center, radius: 10));

    canvas.drawCircle(center, 9, paint);
    canvas.drawCircle(center, 4, Paint()..color = Colors.white);
  }
}
