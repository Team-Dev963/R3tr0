import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CabinetBodyPainter extends CustomPainter {
  final int items;
  final Size size;
  final double itemHeight;

  CabinetBodyPainter(this.items, this.size, this.itemHeight);

  Path path(Size size) => Path()
    ..moveTo(size.width / 2 - 50, 0)
    ..lineTo(size.width / 2 + 50, 0)
    ..lineTo(size.width, size.height)
    ..lineTo(size.width, size.height + items * itemHeight + 2)
    ..lineTo(0, size.height + items * itemHeight + 2)
    ..lineTo(0, size.height)
    ..close();

  @override
  void paint(Canvas canvas, _) {
    canvas.drawPath(
        path(this.size),
        Paint()
          ..color = Colors.grey[800]
          ..strokeWidth = 1.0);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CabinetTopPainter extends CustomPainter {
  static Path path(Size size) => Path()
    ..moveTo(size.width / 2 - 50, 0)
    ..lineTo(size.width / 2 + 50, 0)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    var _path = path(size);
    var paint = Paint()
      ..shader = LinearGradient(colors: [
        Color.fromRGBO(102, 119, 121, 1.0),
        Color.fromRGBO(130, 144, 145, 1.0),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
          .createShader(_path.getBounds());
    canvas.drawPath(_path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CabinetFrontPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Rect.fromLTRB(1, 2, size.width - 1, size.height - 0);
    var paint = Paint()..shader = frontGradient.createShader(rect);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(4.0)), paint);
    var backHandle = Rect.fromLTRB(size.width / 2 - 15, 15, size.width / 2 + 15, size.height - 40);
    var backPaint = Paint()..color = Color.fromRGBO(75, 89, 90, 1.0);
    var backPaintBorder = Paint()
      ..color = Color.fromRGBO(126, 149, 151, 1.0)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(RRect.fromRectAndRadius(backHandle, Radius.circular(4.0)), backPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(backHandle, Radius.circular(4.0)), backPaintBorder);
    var handleRect = Rect.fromLTRB(size.width / 2 - 20, 10, size.width / 2 + 20, size.height - 44);
    var handlePaint = Paint()..shader = handleGradient.createShader(handleRect);
    canvas.drawRRect(RRect.fromRectAndRadius(handleRect, Radius.circular(2.0)), handlePaint);
  }

  static Gradient frontGradient = LinearGradient(
    colors: [Color.fromRGBO(131, 144, 145, 1.0), Color.fromRGBO(88, 99, 101, 1.0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static Gradient handleGradient = LinearGradient(
    colors: [Color.fromRGBO(184, 196, 198, 1.0), Color.fromRGBO(132, 146, 147, 1.0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CabinetInsidePainter extends CustomPainter {
  final double width;

  CabinetInsidePainter({this.width});

  static LinearGradient gradient = LinearGradient(
    colors: [Color.fromRGBO(22, 27, 28, 1.0), Color.fromRGBO(58, 69, 70, 1.0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  Path path(Size size) => Path()
    ..moveTo(2, 0)
    ..lineTo(width - 2, 0)
    ..lineTo(size.width - (size.width - width) / 2 - 4, size.height + 3)
    ..lineTo(4 - (size.width - width) / 2, size.height + 3)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(path(size),
        Paint()..shader = gradient.createShader(Rect.fromLTRB(0, 0, size.width, size.height)));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
