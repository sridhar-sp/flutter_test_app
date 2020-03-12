import 'dart:math';
import 'package:flutter/material.dart';

class PCBLayoutWidget extends StatefulWidget{

  double startX;
  double startY;
  double endX;
  double endY;

  PCBLayoutWidget(this.startX,this.startY,this.endX,this.endY);

  @override
  State<StatefulWidget> createState() {
    return PCBLayoutWidgetState();
  }
}

class PCBLayoutWidgetState extends State<PCBLayoutWidget>{

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: PCBLayoutPainter(widget),
      )
    );
  }
}

class PCBLayoutPainter extends CustomPainter{

  PCBLayoutWidget widget;
  
  PCBLayoutPainter(this.widget);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style=PaintingStyle.stroke
      ..strokeWidth=2
      ..color=Colors.red;

    Path path = new Path();
    path.moveTo(widget.startX, widget.startY);
    path.lineTo(widget.endX, widget.endY);
    canvas.drawPath(path, paint);

//    canvas.drawRect(Rect.fromLTRB(0, 0, 100, 100), paint);

  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
