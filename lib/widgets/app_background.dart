import 'package:flutter/material.dart';
import '../theme/colors.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bone,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Tiled texture background
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/images/texture.png',
                repeat: ImageRepeat.repeat,
                fit: BoxFit.none,
                alignment: Alignment.topLeft,
              ),
            ),
          ),
          // Content
          child,
        ],
      ),
    );
  }
}

