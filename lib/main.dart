import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Dials(),
        ],
      ))),
    );
  }
}

class Dials extends StatefulWidget {
  @override
  _DialsState createState() => _DialsState();
}

class _DialsState extends State<Dials> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double oriX;
  double curX;
  double oriY;
  double curY;
  double angle = 0;
  double rad;

  getradfromcoord() {
    double dist = sqrt(pow((curX - oriX), 2) + pow((curY - oriY), 2));
    rad = 2 * asin(dist / 210);
    setState(() {
      angle = 4 * rad;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800))
          ..addListener(() {
            setState(() {
              angle = _controller.value*8;
            });
          });
    _controller.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
            color: Colors.lightBlueAccent, shape: BoxShape.circle),
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onVerticalDragStart: (Dragstart) {
            oriX = Dragstart.globalPosition.dx;
            oriY = Dragstart.globalPosition.dy;
          },
          onVerticalDragUpdate: (Dragupdate) {
            curX = Dragupdate.globalPosition.dx;
            curY = Dragupdate.globalPosition.dy;
            if (((curX - oriX) < 200) && ((curY - oriY) < 200)) {
              if ((curX - oriX) > 0) {
                getradfromcoord();
              }
            }
          },
          onVerticalDragEnd: (noneed) {
            _controller.value = rad/2;
            _controller.animateTo(0);
          },
          child: Container(
            height: 40,
            width: 40,
            decoration:
                BoxDecoration(color: Colors.black, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
