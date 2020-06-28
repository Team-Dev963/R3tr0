import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r3tr0/ui/paint/cabinet.dart';

offsetFromSize(Size size) {
  if (size.isInfinite) throw Exception;
  return Offset(size.width, size.height);
}

class Cabinet extends StatefulWidget {
  @override
  _CabinetState createState() => _CabinetState();
}

class _CabinetState extends State<Cabinet> with TickerProviderStateMixin {
  List<AnimationController> _controllers;
  int openIndex;

  @override
  void initState() {
    _controllers = List.generate(
        2, (index) => AnimationController(vsync: this, value: 0.0, duration: Duration(seconds: 1)));
    super.initState();
  }

  List<Widget> getChildren() {
    List<Widget> list = [];

    for (var i = 0; i < 2; i++) {
      if (i != openIndex)
        list.add(Positioned(
          top: (i + 1) * 64.0,
          child: CabinetDrawer(
              index: i,
              animation: _controllers[i],
              onOpen: (int index) {
                print(openIndex);
                if (openIndex != null && openIndex != index) {
                  _controllers[openIndex].reverse().then((_) {
                    setState(() {
                      openIndex = index;
                    });
                    _controllers[index].forward();
                  });
                } else {
                  setState(() {
                    openIndex = index;
                  });
                  _controllers[index].forward();
                }
              },
              onClose: (int index) {
                _controllers[index].reverse().then((value) => setState(() {
                      openIndex = null;
                    }));
              }),
        ));
    }
    if (openIndex != null) {
      list.add(
        Positioned(
          top: (openIndex + 1) * 64.0,
          child: AnimatedBuilder(
            animation: _controllers[openIndex],
            builder: (context, child) {
              return CustomPaint(
                painter: CabinetInsidePainter(width: 200),
                size: Size(200 + 40 * _controllers[openIndex].value,
                    80 * 0.72 * _controllers[openIndex].value),
              );
            },
          ),
        ),
      );
      list.add(Positioned(
        top: (openIndex + 1) * 64.0,
        child: CabinetDrawer(
            index: openIndex,
            animation: _controllers[openIndex],
            onOpen: (int index) {
              print(openIndex);
              if (openIndex != null && openIndex != index) {
                _controllers[openIndex].reverse().then((_) {
                  setState(() {
                    openIndex = index;
                  });
                  _controllers[index].forward();
                });
              } else {
                setState(() {
                  openIndex = index;
                });
                _controllers[index].forward();
              }
            },
            onClose: (int index) {
              _controllers[index].reverse().then((value) => setState(() {
                    openIndex = null;
                  }));
            }),
      ));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40.0),
      child: CustomPaint(
        painter: CabinetBodyPainter(2, Size(200, 64)),
        child: Stack(
          children: [
            CustomPaint(
              size: Size(200, 64),
              painter: CabinetTopPainter(),
              child: Container(width: 200, height: 64),
            ),
            ...getChildren()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllers.forEach((el) => el.dispose());
    super.dispose();
  }
}

class CabinetDrawer extends StatefulWidget {
  CabinetDrawer({this.animation, this.index, this.onOpen, this.onClose});

  final int index;
  final Function(int) onOpen;
  final Function(int) onClose;
  final AnimationController animation;

  @override
  _CabinetDrawerState createState() => _CabinetDrawerState();
}

class _CabinetDrawerState extends State<CabinetDrawer> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        if (widget.animation.value == 0) {
          return child;
        }
        var scale = widget.animation.value * 0.2 + 1;
        var translateX = widget.animation.value * (-32 * 0.5);
        var translateY = widget.animation.value * 48.0;
        return Transform(
          transform: Matrix4.identity()
            ..scale(scale, scale)
            ..translate(translateX, translateY),
          child: child,
        );
      },
      child: CustomPaint(
        size: Size(200, 64),
        painter: CabinetFrontPainter(),
        child: GestureDetector(
          onTap: () {
            print('tap ${widget.index} ${widget.animation.status}');
            if (widget.animation.isCompleted) {
              print('closing ${widget.index}');
              widget.onClose(widget.index);
            } else {
              print('opening ${widget.index}');
              widget.onOpen(widget.index);
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 200,
            height: 64,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
