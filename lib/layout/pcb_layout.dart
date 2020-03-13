import 'dart:math';

import 'package:flutter/material.dart';

class PCBLayout extends StatelessWidget {
  final List<PointPair> pointsList;
  PCBLayout(this.pointsList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: _PCBLayoutPainter(pointsList),
      ),
    );
  }
}

class _PCBLayoutPainter extends CustomPainter {
  final List<PointPair> pointsList;
  _PCBLayoutPainter(this.pointsList);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.red;

    Path path = new Path();
    pointsList.forEach((element) {
      path.moveTo(element.start.x, element.start.y);
      path.lineTo(element.end.x, element.end.y);

      canvas.drawPath(path, paint);
    });

//    canvas.drawRect(Rect.fromLTRB(0, 0, 100, 100), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PointPair {
  Point _start;
  Point _end;

  PointPair(this._start, this._end);

  Point get start => _start;

  Point get end => _end;

  set start(Point start) {
    this._start = start;
  }

  set end(Point end) {
    this._end = end;
  }
}
