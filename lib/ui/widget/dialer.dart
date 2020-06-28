import 'dart:math' show pi, sin, cos, sqrt, pow, atan2;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

euclideanDist(Offset a, Offset b) {
  return sqrt(pow((a.dx - b.dx), 2) + pow((a.dy - b.dy), 2));
}

class Dialer extends StatefulWidget {
  @override
  _DialerState createState() => _DialerState();
}

class _DialerState extends State<Dialer> with TickerProviderStateMixin {
  Offset center = Offset.zero;
  AnimationController _controller;

  double oriX;
  double oriY;

  double curX;
  double curY;

  double angle = 0;

  updateAngle() {
    var origAngle = atan2(oriY - center.dy, oriX - center.dx);
    var curAngle = atan2(curY - center.dy, curX - center.dx);
    angle = curAngle - origAngle;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      value: 0.0,
      lowerBound: -pi,
      upperBound: pi,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      center =
          Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2);
      print(center);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onVerticalDragStart: (dragStart) {
          oriX = dragStart.globalPosition.dx;
          oriY = dragStart.globalPosition.dy;
        },
        onVerticalDragUpdate: (dragUpdate) {
          curX = dragUpdate.globalPosition.dx;
          curY = dragUpdate.globalPosition.dy;
          updateAngle();
          _controller.animateTo(angle);
        },
        onHorizontalDragStart: (dragStart) {
          oriX = dragStart.globalPosition.dx;
          oriY = dragStart.globalPosition.dy;
        },
        onHorizontalDragUpdate: (dragUpdate) {
          curX = dragUpdate.globalPosition.dx;
          curY = dragUpdate.globalPosition.dy;
          updateAngle();
          _controller.animateTo(angle);
        },
        onHorizontalDragEnd: (_) {
          _controller.animateTo(0);
        },
        onVerticalDragEnd: (_) {
          _controller.animateTo(0);
        },
        child: CustomPaint(
          painter: DialerBackGroundPainter(width: 300),
          child: Container(
            width: 300,
            height: 300,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                print('angle: ${_controller.value}');
                return Transform.rotate(angle: _controller.value, child: child);
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
