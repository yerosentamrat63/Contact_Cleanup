import 'package:flutter/material.dart';
import '../theme/colors.dart';

class UndoIcon extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const UndoIcon({
    super.key,
    this.size = 22,
    this.color = AppColors.smokyBlack,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _UndoPainter(color: color, strokeWidth: strokeWidth),
    );
  }
}

class _UndoPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _UndoPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth * scale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // d="M9 14L4 9l5-5"
    final path1 = Path()
      ..moveTo(9 * scale, 14 * scale)
      ..lineTo(4 * scale, 9 * scale)
      ..lineTo(9 * scale, 4 * scale);

    // d="M4 9h10a6 6 0 010 12h-3"
    final path2 = Path()
      ..moveTo(4 * scale, 9 * scale)
      ..lineTo(14 * scale, 9 * scale)
      ..arcToPoint(
        Offset(14 * scale, 21 * scale),
        radius: Radius.circular(6 * scale),
        clockwise: true,
      )
      ..lineTo(11 * scale, 21 * scale);

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant _UndoPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class CheckIcon extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const CheckIcon({
    super.key,
    this.size = 24,
    this.color = AppColors.sageInk,
    this.strokeWidth = 2.4,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CheckPainter(color: color, strokeWidth: strokeWidth),
    );
  }
}

class _CheckPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _CheckPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth * scale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // d="M5 12l5 5L20 7"
    final path = Path()
      ..moveTo(5 * scale, 12 * scale)
      ..lineTo(10 * scale, 17 * scale)
      ..lineTo(20 * scale, 7 * scale);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class TrashIcon extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const TrashIcon({
    super.key,
    this.size = 28,
    this.color = AppColors.terracotta,
    this.strokeWidth = 2.2,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TrashPainter(color: color, strokeWidth: strokeWidth),
    );
  }
}

class _TrashPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _TrashPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth * scale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Bar: d="M4 7h16"
    canvas.drawLine(
        Offset(4 * scale, 7 * scale), Offset(20 * scale, 7 * scale), paint);

    // Inner lines: d="M10 11v6M14 11v6"
    canvas.drawLine(
        Offset(10 * scale, 11 * scale), Offset(10 * scale, 17 * scale), paint);
    canvas.drawLine(
        Offset(14 * scale, 11 * scale), Offset(14 * scale, 17 * scale), paint);

    // Can body: d="M6 7l1 12a2 2 0 002 2h6a2 2 0 002-2l1-12"
    final body = Path()
      ..moveTo(6 * scale, 7 * scale)
      ..lineTo(7 * scale, 19 * scale)
      ..arcToPoint(
        Offset(9 * scale, 21 * scale),
        radius: Radius.circular(2 * scale),
        clockwise: false,
      )
      ..lineTo(15 * scale, 21 * scale)
      ..arcToPoint(
        Offset(17 * scale, 19 * scale),
        radius: Radius.circular(2 * scale),
        clockwise: false,
      )
      ..lineTo(18 * scale, 7 * scale);
    canvas.drawPath(body, paint);

    // Lid handle: d="M9 7V4h6v3"
    final lid = Path()
      ..moveTo(9 * scale, 7 * scale)
      ..lineTo(9 * scale, 4 * scale)
      ..lineTo(15 * scale, 4 * scale)
      ..lineTo(15 * scale, 7 * scale);
    canvas.drawPath(lid, paint);
  }

  @override
  bool shouldRepaint(covariant _TrashPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class ArrowLeftIcon extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const ArrowLeftIcon({
    super.key,
    this.size = 22,
    this.color = AppColors.smokyBlack,
    this.strokeWidth = 2.4,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ArrowLeftPainter(color: color, strokeWidth: strokeWidth),
    );
  }
}

class _ArrowLeftPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _ArrowLeftPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth * scale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Line: d="M19 12H5"
    canvas.drawLine(
        Offset(19 * scale, 12 * scale), Offset(5 * scale, 12 * scale), paint);

    // Arrowhead: d="M12 19l-7-7 7-7"
    final head = Path()
      ..moveTo(12 * scale, 19 * scale)
      ..lineTo(5 * scale, 12 * scale)
      ..lineTo(12 * scale, 5 * scale);
    canvas.drawPath(head, paint);
  }

  @override
  bool shouldRepaint(covariant _ArrowLeftPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class ArrowRightIcon extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const ArrowRightIcon({
    super.key,
    this.size = 22,
    this.color = AppColors.terracotta,
    this.strokeWidth = 2.4,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ArrowRightPainter(color: color, strokeWidth: strokeWidth),
    );
  }
}

class _ArrowRightPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _ArrowRightPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth * scale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Line: d="M5 12h14"
    canvas.drawLine(
        Offset(5 * scale, 12 * scale), Offset(19 * scale, 12 * scale), paint);

    // Arrowhead: d="M13 6l6 6-6 6"
    final head = Path()
      ..moveTo(13 * scale, 6 * scale)
      ..lineTo(19 * scale, 12 * scale)
      ..lineTo(13 * scale, 18 * scale);
    canvas.drawPath(head, paint);
  }

  @override
  bool shouldRepaint(covariant _ArrowRightPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class LockIcon extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const LockIcon({
    super.key,
    this.size = 52,
    this.color = AppColors.floralWhite,
    this.strokeWidth = 1.8,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _LockPainter(color: color, strokeWidth: strokeWidth),
    );
  }
}

class _LockPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _LockPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth * scale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Body: <rect x="5" y="11" width="14" height="10" rx="2">
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(5 * scale, 11 * scale, 14 * scale, 10 * scale),
      Radius.circular(2 * scale),
    );
    canvas.drawRRect(rrect, paint);

    // Shackle: <path d="M8 11V8a4 4 0 018 0v3">
    final shackle = Path()
      ..moveTo(8 * scale, 11 * scale)
      ..lineTo(8 * scale, 8 * scale)
      ..arcToPoint(
        Offset(16 * scale, 8 * scale),
        radius: Radius.circular(4 * scale),
        clockwise: true,
      )
      ..lineTo(16 * scale, 11 * scale);
    canvas.drawPath(shackle, paint);
  }

  @override
  bool shouldRepaint(covariant _LockPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

