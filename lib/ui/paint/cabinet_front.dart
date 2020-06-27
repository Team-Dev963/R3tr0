import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

offsetFromSize(Size size) {
  if (size.isInfinite) throw Exception;
  return Offset(size.width, size.height);
}

class Cabinet extends StatefulWidget {
  @override
  _CabinetState createState() => _CabinetState();
}

class _CabinetState extends State<Cabinet> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _controller2;
  bool a = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1), value: 0);
    _controller2 = AnimationController(vsync: this, duration: Duration(seconds: 1), value: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: _CabinetBodyPainter(2, Size(200, 64)),
        child: Column(
          children: [
            CustomPaint(
              size: Size(200, 64),
              painter: _CabinetTopPainter(),
              child: Container(
                width: 200,
                height: 64,
              ),
            ),
            AnimatedBuilder(
              animation: _controller2,
              builder: (context, child) {
                if (_controller2.value == 0) {
                  return child;
                }
                var scale = _controller2.value * 0.2 + 1;
                var translateX = _controller2.value * (-32 * 0.5);
                var translateY = _controller2.value * 80.0;
                return Transform(
                  transform: Matrix4.identity()
                    ..scale(scale, scale)
                    ..translate(translateX, translateY),
                  child: child,
                );
              },
              child: CustomPaint(
                size: Size(200, 64),
                painter: _CabinetFrontPainter(),
                child: GestureDetector(
                  onTap: () {
                    print('onTap');
                    if (_controller2.isCompleted) {
                      _controller2.reverse();
                    } else {
                      _controller2.forward();
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 200,
                    height: 64,
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                if (_controller.value == 0) {
                  return child;
                }
                var scale = _controller.value * 0.2 + 1;
                var translateX = _controller.value * (-32 * 0.5);
                var translateY = _controller.value * 80.0;
                return Transform(
                  transform: Matrix4.identity()
                    ..scale(scale, scale)
                    ..translate(translateX, translateY),
                  child: child,
                );
              },
              child: CustomPaint(
                size: Size(200, 64),
                painter: _CabinetFrontPainter(),
                child: GestureDetector(
                  onTap: () {
                    print('onTap');
                    if (_controller.isCompleted) {
                      _controller.reverse();
                    } else {
                      _controller.forward();
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 200,
                    height: 64,
                  ),
                ),
              ),
            ),
          ],
          mainAxisSize: MainAxisSize.max,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }
}

class _CabinetBodyPainter extends CustomPainter {
  final int items;
  final Size size;

  _CabinetBodyPainter(this.items, this.size);

  Path path(Size size) => Path()
    ..moveTo(size.width / 2 - 51, -2)
    ..lineTo(size.width / 2 + 51, -2)
    ..lineTo(size.width + 2, size.height)
    ..lineTo(size.width + 1, size.height * (items + 1) + 2)
    ..lineTo(-1, size.height * (items + 1) + 2)
    ..lineTo(-2, size.height)
    ..close();

  @override
  void paint(Canvas canvas, _) {
    canvas.drawPath(
        path(this.size),
        Paint()
          ..color = Colors.grey[900]
          ..strokeWidth = 2.0);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _CabinetTopPainter extends CustomPainter {
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

class _CabinetFrontPainter extends CustomPainter {
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
