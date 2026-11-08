import 'package:flutter/material.dart';
import '../theme/colors.dart';

class AppCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  const AppCheckbox({
    super.key,
    required this.isChecked,
    this.onChanged,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: isChecked,
      label: semanticLabel,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onChanged != null ? () => onChanged!(!isChecked) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isChecked ? AppColors.terracotta : AppColors.floralWhite,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: isChecked ? AppColors.terracotta : AppColors.oliveDrab,
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: isChecked ? 1.0 : 0.0,
            child: const _CheckboxCheck(size: 16, strokeWidth: 3.4),
          ),
        ),
      ),
    );
  }
}

class _CheckboxCheck extends StatelessWidget {
  final double size;
  final double strokeWidth;

  const _CheckboxCheck({
    required this.size,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CheckboxCheckPainter(strokeWidth: strokeWidth),
    );
  }
}

class _CheckboxCheckPainter extends CustomPainter {
  final double strokeWidth;

  _CheckboxCheckPainter({required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    final paint = Paint()
      ..color = AppColors.floralWhite
      ..strokeWidth = strokeWidth * scale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // d="M5 12.5l4.5 4.5L19 7.5"
    final path = Path()
      ..moveTo(5 * scale, 12.5 * scale)
      ..lineTo(9.5 * scale, 17 * scale)
      ..lineTo(19 * scale, 7.5 * scale);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckboxCheckPainter oldDelegate) =>
      oldDelegate.strokeWidth != strokeWidth;
}

