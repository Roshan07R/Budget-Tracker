import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLogoWidget({
    super.key,
    this.size = 80,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? const Color(0xFF10B981);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: BudgetTrackerLogoPainter(color: logoColor),
        child: Container(), // Empty container to give the CustomPaint a size
      ),
    );
  }
}

class BudgetTrackerLogoPainter extends CustomPainter {
  final Color color;

  BudgetTrackerLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // Draw the circular background
    canvas.drawCircle(center, radius, paint);

    // Draw the stylized "B" for Budget
    final bPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final bPath = Path();

    // Left vertical line of "B"
    final leftX = center.dx - radius * 0.3;
    final topY = center.dy - radius * 0.5;
    final bottomY = center.dy + radius * 0.5;

    bPath.moveTo(leftX, topY);
    bPath.lineTo(leftX, bottomY);
    bPath.lineTo(leftX + radius * 0.1, bottomY);
    bPath.lineTo(leftX + radius * 0.1, topY);
    bPath.close();

    // Top curve of "B"
    final topCurveRect = Rect.fromLTWH(
      leftX + radius * 0.1,
      topY,
      radius * 0.4,
      radius * 0.4,
    );
    bPath.addRRect(RRect.fromRectAndRadius(
      topCurveRect,
      const Radius.circular(8),
    ));

    // Bottom curve of "B"
    final bottomCurveRect = Rect.fromLTWH(
      leftX + radius * 0.1,
      center.dy - radius * 0.1,
      radius * 0.5,
      radius * 0.4,
    );
    bPath.addRRect(RRect.fromRectAndRadius(
      bottomCurveRect,
      const Radius.circular(8),
    ));

    canvas.drawPath(bPath, bPaint);

    // Draw subtle dollar sign integrated into the "B"
    final dollarPaint = Paint()
      ..color = Colors.white.withAlpha(204)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final dollarPath = Path();
    dollarPath.moveTo(center.dx + radius * 0.2, center.dy - radius * 0.2);
    dollarPath.quadraticBezierTo(
      center.dx + radius * 0.35,
      center.dy - radius * 0.1,
      center.dx + radius * 0.2,
      center.dy,
    );
    dollarPath.quadraticBezierTo(
      center.dx + radius * 0.05,
      center.dy + radius * 0.1,
      center.dx + radius * 0.2,
      center.dy + radius * 0.2,
    );

    canvas.drawPath(dollarPath, dollarPaint);

    // Draw vertical line for dollar sign
    dollarPath.moveTo(center.dx + radius * 0.2, center.dy - radius * 0.3);
    dollarPath.lineTo(center.dx + radius * 0.2, center.dy + radius * 0.3);
    canvas.drawPath(dollarPath, dollarPaint);

    // Draw rising graph arrow
    final arrowPaint = Paint()
      ..color = Colors.white.withAlpha(230)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final arrowPath = Path();
    // Arrow line going up
    arrowPath.moveTo(center.dx - radius * 0.4, center.dy + radius * 0.2);
    arrowPath.lineTo(center.dx - radius * 0.15, center.dy - radius * 0.1);
    arrowPath.lineTo(center.dx + radius * 0.1, center.dy - radius * 0.3);
    arrowPath.lineTo(center.dx + radius * 0.35, center.dy - radius * 0.4);

    canvas.drawPath(arrowPath, arrowPaint);

    // Arrow head
    final arrowHeadPath = Path();
    arrowHeadPath.moveTo(center.dx + radius * 0.35, center.dy - radius * 0.4);
    arrowHeadPath.lineTo(center.dx + radius * 0.25, center.dy - radius * 0.35);
    arrowHeadPath.lineTo(center.dx + radius * 0.3, center.dy - radius * 0.3);
    arrowHeadPath.close();

    canvas.drawPath(
        arrowHeadPath,
        Paint()
          ..color = Colors.white.withAlpha(230)
          ..style = PaintingStyle.fill);

    // Add some subtle data points
    final pointPaint = Paint()
      ..color = Colors.white.withAlpha(153)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy + radius * 0.1),
      2,
      pointPaint,
    );
    canvas.drawCircle(
      Offset(center.dx - radius * 0.05, center.dy - radius * 0.05),
      2,
      pointPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.2, center.dy - radius * 0.25),
      2,
      pointPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
