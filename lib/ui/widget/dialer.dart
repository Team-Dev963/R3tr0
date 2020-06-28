import 'dart:math' show pi, sin, cos, sqrt, pow, asin;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class Dialer extends StatefulWidget {
  @override
  _DialerState createState() => _DialerState();
}

class _DialerState extends State<Dialer> with TickerProviderStateMixin {
  AnimationController _controller;
  double oriX;
  double curX;
  double oriY;
  double curY;
  double angle = 0;
  double rad;

  getRadFromCoOrd() {
    double dist = sqrt(pow((curX - oriX), 2) + pow((curY - oriY), 2));
    rad = 2 * asin(dist / 210);
    setState(() {
      angle = 4 * rad;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, value: 0.0, duration: Duration(milliseconds: 800))
          ..addListener(() {
            setState(() {
              angle = _controller.value * 8;
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: DialerBackGroundPainter(width: 300),
        child: Container(
          width: 300,
          height: 300,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(angle: angle, child: child);
            },
            child: GestureDetector(
              onVerticalDragStart: (dragStart) {
                oriX = dragStart.globalPosition.dx;
                oriY = dragStart.globalPosition.dy;
              },
              onVerticalDragUpdate: (dragUpdate) {
                curX = dragUpdate.globalPosition.dx;
                curY = dragUpdate.globalPosition.dy;
                if (((curX - oriX) < 200) && ((curY - oriY) < 200)) {
                  if ((curX - oriX) > 0) {
                    getRadFromCoOrd();
                  }
                }
              },
              onVerticalDragEnd: (_) {
                _controller.value = rad / 2;
                _controller.animateTo(0);
              },
              child: Image.asset(
                'assets/images/dial.png',
                width: 300,
                height: 300,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class DialerBackGroundPainter extends CustomPainter {
  final double width;

  DialerBackGroundPainter({this.width});

  @override
  void paint(Canvas canvas, Size size) {
    var outerRect = Rect.fromCircle(center: Offset(width / 2, width / 2), radius: width / 2 + 5);
    var innerRect = Rect.fromCircle(center: Offset(width / 2, width / 2), radius: width / 4 - 10);
    canvas.drawDRRect(
      RRect.fromRectAndRadius(outerRect, Radius.circular(width)),
      RRect.fromRectAndRadius(innerRect, Radius.circular(width)),
      Paint()..color = Colors.black,
    );
    for (var i = 1; i <= 10; i++) {
      Offset center = getCenterPos(i);
      print(center);
      var x = ui.ParagraphBuilder(ui.ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 20,
      ))
        ..addText('${i % 10}');
      var p = x.build();
      p.layout(ui.ParagraphConstraints(width: width / 4));
      canvas.drawParagraph(p, center);
    }
  }

  Offset getCenterPos(int i) {
    var radius = width / 2 * 3 / 4;
    // Position of number
    var angle = (2 * pi / 12) * -i;
    return Offset(cos(angle) * radius, sin(angle) * radius)
        .translate(width / 2 - width / 8, width / 2 - width / 32);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
