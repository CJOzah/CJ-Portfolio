import 'dart:math';

import 'package:flutter/material.dart';

class RandomMovingShape extends StatefulWidget {
  const RandomMovingShape(
      {Key? key,
      required this.maxY,
      required this.maxX,
      required this.curve,
      required this.color,
      required this.radius,
      required this.painter,
      required this.minX,
      required this.minY})
      : super(key: key);

  final int maxY;
  final int maxX;
  final int minX;
  final int minY;
  final Curve curve;
  final Color color;
  final BorderRadius radius;
  final CustomPainter painter;

  @override
  State<RandomMovingShape> createState() => _RandomMovingShapeState();
}

class _RandomMovingShapeState extends State<RandomMovingShape>
    with TickerProviderStateMixin {
  AnimationController? _controllerA;

  AnimationController? _controllerB;

  double offset1 = 1.75;

  double offset2 = 0.0;

  Random random = Random();

  int minX = 5;
  int minY = 5;
  int? rX, rY;

  animateShapes() {
    rX = minX + random.nextInt(widget.maxX);
    rY = minY + random.nextInt(widget.maxY);
    // print("rx $rX, ry $rY");
    _controllerA = AnimationController(
        vsync: this,
        lowerBound: rY!.toDouble() - 20,
        upperBound: rY!.toDouble(),
        duration: Duration(milliseconds: 5000));
    _controllerA!.addListener(() {
      setState(() {
        offset1 = _controllerA!.value.abs();
      });
    });
    _controllerB = AnimationController(
        vsync: this,
        lowerBound: rX!.toDouble() - 20,
        upperBound: rX!.toDouble(),
        duration: Duration(milliseconds: 5000));
    _controllerB!.addListener(() {
      setState(() {
        offset2 = _controllerB!.value.abs();
      });
    });

    _controllerA!.forward();
    _controllerB!.forward();
  }

  @override
  void initState() {
    offset1 = widget.minY.toDouble();
    offset2 = widget.minX.toDouble();
    // _controllerA = AnimationController(
    //     vsync: this,
    //     lowerBound: 0.6,
    //     upperBound: 300.75,
    //     duration: Duration(milliseconds: 5000));
    // _controllerA!.addListener(() {
    //   setState(() {
    //     offset1 = _controllerA!.value;
    //   });
    // });
    // _controllerB = AnimationController(
    //     vsync: this,
    //     lowerBound: 0.0,
    //     upperBound: 500.6,
    //     duration: Duration(milliseconds: 5000));
    // _controllerB!.addListener(() {
    //   setState(() {
    //     offset2 = _controllerB!.value;
    //   });
    // });

    animateShapes();

    super.initState();
  }

  @override
  void dispose() {
    _controllerA!.dispose();
    _controllerB!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (offset2 == rX && offset1 == rY) {
      // print("top $offset1, left $offset2");
      setState(() {
        Future.delayed(Duration(milliseconds: 2000))
            .then((value) => animateShapes());
        animateShapes();
      });
    }
    return AnimatedContainer(
      margin: EdgeInsets.only(top: offset1 + 10, left: offset2 + 10),
      curve: widget.curve,
      duration: Duration(seconds: 3),
      child: CustomPaint(
        size: Size(60, 60),
        painter: widget.painter,
      ),
    );
  }
}
