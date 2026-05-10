import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/glide_tokens.dart';

class MapBackground extends StatelessWidget {
  final bool dark;
  final bool route;

  const MapBackground({super.key, this.dark = false, this.route = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: _MapPainter(dark: dark, route: route),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final bool dark;
  final bool route;

  const _MapPainter({required this.dark, this.route = false});

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 390;
    final scaleY = size.height / 800;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    final base = dark ? const Color(0xFF0F1115) : const Color(0xFFEFEFE9);
    final dot = dark ? const Color(0x0FFFFFFF) : const Color(0x0D000000);
    final blk1 = dark ? const Color(0xFF13181A) : const Color(0xFFE7ECDF);
    final blk2 = dark ? const Color(0xFF1A1814) : const Color(0xFFEFE9DC);
    final blk3 = dark ? const Color(0xFF11181A) : const Color(0xFFE5EAE0);
    final blk4 = dark ? const Color(0xFF1A1814) : const Color(0xFFEEE9DC);
    final road = dark ? const Color(0xFF22262C) : const Color(0xFFFFFFFF);
    final roadEdge = dark ? const Color(0x0AFFFFFF) : const Color(0x0F000000);
    final minor = dark ? const Color(0xFF1B2024) : const Color(0xFFFFFFFF);
    final label = dark ? const Color(0x4DDCDCDC) : const Color(0x72606067);

    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 390, 800),
      Paint()..color = base,
    );

    final dotPaint = Paint()..color = dot;
    for (double x = 1; x < 390; x += 22) {
      for (double y = 1; y < 800; y += 22) {
        canvas.drawCircle(Offset(x, y), 0.8, dotPaint);
      }
    }

    _fillRect(canvas, -20, 120, 180, 160, blk1, 0.7);
    _fillRect(canvas, 220, 60, 220, 120, blk2, 0.55);
    _fillRect(canvas, 240, 380, 200, 180, blk3, 0.55);
    _fillRect(canvas, -20, 540, 200, 180, blk4, 0.55);

    _drawRoads(canvas, Paint()
      ..color = road
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke);

    _drawRoads(canvas, Paint()
      ..color = roadEdge
      ..strokeWidth = 14.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke);

    _drawMinorRoads(canvas, Paint()
      ..color = minor.withValues(alpha: 0.9)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke);

    _drawLabel(canvas, 'VAN HOUTEN AVE', 200, 195, 2, label);
    _drawLabel(canvas, 'SPRING ST', 200, 455, -2, label);
    _drawLabel(canvas, 'MT PROSPECT', 106, 380, -89, label);
    _drawLabel(canvas, 'CHESTNUT BLVD', 304, 380, 89, label);

    if (route) {
      final routePath = Path()
        ..moveTo(110, 600)
        ..quadraticBezierTo(200, 540, 200, 460)
        ..quadraticBezierTo(200, 380, 290, 280);
      canvas.drawPath(
        routePath,
        Paint()
          ..color = kAccent
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      );
    }

    canvas.restore();
  }

  void _fillRect(Canvas canvas, double x, double y, double w, double h, Color c, double opacity) {
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()..color = c.withValues(alpha: opacity),
    );
  }

  void _drawRoads(Canvas canvas, Paint paint) {
    canvas.drawLine(const Offset(-20, 180), const Offset(460, 220), paint);
    canvas.drawLine(const Offset(-20, 480), const Offset(460, 460), paint);
    canvas.drawLine(const Offset(120, -20), const Offset(100, 820), paint);
    canvas.drawLine(const Offset(280, -20), const Offset(310, 820), paint);
  }

  void _drawMinorRoads(Canvas canvas, Paint paint) {
    canvas.drawLine(const Offset(-20, 320), const Offset(460, 340), paint);
    canvas.drawLine(const Offset(-20, 620), const Offset(460, 600), paint);
    canvas.drawLine(const Offset(40, -20), const Offset(60, 820), paint);
    canvas.drawLine(const Offset(200, -20), const Offset(210, 820), paint);
    canvas.drawLine(const Offset(380, -20), const Offset(390, 820), paint);
  }

  void _drawLabel(Canvas canvas, String text, double x, double y, double deg, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 9, letterSpacing: 0.5),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(deg * pi / 180);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_MapPainter old) => old.dark != dark || old.route != route;
}
