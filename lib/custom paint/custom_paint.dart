import 'package:flutter/material.dart';

class DrawTriangleShape extends CustomPainter {
  final Color color;

  Paint? painter;

  DrawTriangleShape({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    painter = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.height, size.width);
    path.close();

    canvas.drawPath(path, painter!);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class StarPainter extends CustomPainter {
  StarPainter({required this.color, required this.isFilled});
  final Color color;
  final bool isFilled;

  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height;
    double sw = size.width;
    double dx = 0.15;
    double dy = 0.1;

    final paint;

    if (isFilled == true) {
      paint = Paint()
        ..color = color.withOpacity(0.4)
        ..strokeWidth = 3
        ..style = PaintingStyle.fill;
    } else {
      paint = Paint()
        ..color = color.withOpacity(0.4)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;
    }

    Path path = Path()
      ..moveTo(sw / 2, 0)
      ..cubicTo(sw * (0.5 + dx), sh * (0.5 - dy), sw * (0.5 + dy),
          sh * (0.5 - dx), sw, sh / 2)
      ..cubicTo(sw * (0.5 + dy), sh * (0.5 + dx), sw * (0.5 + dx),
          sh * (0.5 + dy), sw / 2, sh)
      ..cubicTo(sw * (0.5 - dx), sh * (0.5 + dy), sw * (0.5 - dy),
          sh * (0.5 + dx), 0, sh / 2)
      ..cubicTo(sw * (0.5 - dy), sh * (0.5 - dx), sw * (0.5 - dx),
          sh * (0.5 - dy), sw / 2, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Rectangle extends CustomPainter {
  bool? isFilled;

  final Color color;
  Rectangle({required this.color, this.isFilled});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color.withOpacity(0.4);
    if (isFilled != null) {
      paint.style = PaintingStyle.fill;
    } else {
      paint.style = PaintingStyle.stroke;
    }
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;
    paint.strokeWidth = 5;
    Offset offset = Offset(size.width * 0.5, size.height);

    Rect rect = Rect.fromCenter(center: offset, width: 50, height: 50);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant Rectangle oldDelegate) {
    return false;
  }
}

class Circle extends CustomPainter {
  final Color color;

  Circle({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color.withOpacity(0.4);
    paint.style = PaintingStyle.fill;
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;

    Offset offset = Offset(size.width * 0.5, size.height);
    canvas.drawCircle(offset, 30, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class DrawCircleCircle extends CustomPainter {
  final Color color1;
  final Color color2;

  DrawCircleCircle({required this.color1, required this.color2});
  // ..strokeWidth = 16
  // ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final paint1;
    final paint2;

    paint1 = Paint()..color = color1.withOpacity(0.4);
    paint2 = Paint()..color = color2.withOpacity(0.4);

    canvas.drawCircle(Offset(0.0, 0.0), 30, paint1);
    canvas.drawCircle(Offset(0.0, 0.0), 25, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
