import 'package:flutter/material.dart';
import 'package:mirror_world_runner/widgets/animated_button.dart';

class HolographicButton extends StatelessWidget {
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;
  final double? width;
  final double? fontSize;
  final double verticalPadding;

  const HolographicButton({
    super.key,
    required this.label,
    required this.colors,
    required this.onTap,
    this.fontSize = 16,
    this.width = 280,
    this.verticalPadding = 20,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: 30,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
