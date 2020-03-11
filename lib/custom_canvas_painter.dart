import 'dart:math';
import 'package:flutter/material.dart';

class NotGateWidget extends StatelessWidget{

  NotGateWidget({Key key}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: SafeArea(
        child: GestureDetector(
          child: CustomPaint(
            painter: NotGatePainter(),
          ),
          onTapDown: (details) {
            RenderBox renderBox= context.findRenderObject();
            final offset = renderBox.globalToLocal(details.globalPosition);

            print("onTapDown ${details.toString()} RenderBox ${offset}");
          },
        ),
      ),
    );
  }
}

class NotGatePainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint paint = Paint();

    paint.style = PaintingStyle.stroke;
    paint.color = Colors.red;
    paint.strokeWidth = 2;

    Path path = Path();

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    double centerX = size.width/2.0;
    double centerY = size.height/2.0;
//
//    path.moveTo(0 , centerY);
//    path.lineTo(size.width, centerY);
//
//    path.moveTo(centerX, centerY-50);
//    path.lineTo(0, centerY);
//
//    path.moveTo(centerX, centerY-50);
//    path.lineTo(size.width, centerY);

    const double padding  = 10.0;
    path.moveTo(centerX, padding);
    path.lineTo(padding,size.height/2);
    path.lineTo(size.width-padding, size.height/2);
    path.close();
    canvas.drawPath(path, paint);

    //Draw input leg
    path.moveTo(centerX, centerY);
    path.lineTo(centerX, size.height/2+50);
    canvas.drawPath(path, paint);

    canvas.drawCircle(Offset(centerX,5), 5, paint);


//    canvas.drawCircle(Offset(centerX-size.width/2,25), 20.0, paint);

//    path.quadraticBezierTo(size.width* 0.10, size.height*0.70,   size.width*0.17, size.height*0.90);
//    path.quadraticBezierTo(size.width*0.20, size.height, size.width*0.25, size.height*0.90);
//    path.quadraticBezierTo(size.width*0.40, size.height*0.40, size.width*0.50, size.height*0.70);
//    path.quadraticBezierTo(size.width*0.60, size.height*0.85, size.width*0.65, size.height*0.65);
//    path.quadraticBezierTo(size.width*0.70, size.height*0.90, size.width, 0);
//    path.close();
  
//    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class AndGateWidget extends StatefulWidget{

  AndGateWidget({Key key}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return AndGateState();
  }
}

class AndGateState extends State<AndGateWidget>{

  @override
  Widget build(BuildContext context) {
   return Container(
     padding: const EdgeInsets.all(2.0),
     child: CustomPaint(
       painter: AndGatePainter(),
     ),
   );
  }
}

class AndGatePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {

    Paint paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.red;
    paint.strokeWidth = 2.0;

    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), paint);

    double centerX = size.width/2;
    double centerY = size.height/2;

    const double padding = 10;

    Path path = Path();
    path.moveTo(padding, centerY);
    path.lineTo(size.width-padding, centerY);

    canvas.drawPath(path, paint);//Middle straight line

    final arcRect = Rect.fromLTWH(padding, padding, size.width-padding*2, size.height/2);

    path.moveTo(padding, centerY);
    path.lineTo(padding, arcRect.bottom-padding); // Left arc leg

    path.addArc(arcRect, pi, pi); //arc

    path.moveTo(size.width-padding, centerY);
    path.lineTo(size.width-padding, arcRect.height/2 +padding );//Right arc leg

    canvas.drawPath(path, paint);

//    canvas.drawArc(Rect.fromCircle(center:Offset(size.width/2,size.height/2),radius: min(size.width/2-padding, size.height/2-padding)),
//        3.14, 3.14, false, paint);

    const legStartPadding = 20;
    const legHeight = 50;

    path.moveTo(padding+legStartPadding, centerY);
    path.lineTo(padding+legStartPadding, centerY+legHeight); // Input leg 1

    canvas.drawPath(path, paint);

    path.moveTo(size.width-padding-legStartPadding, centerY);
    path.lineTo(size.width-padding-legStartPadding, centerY+legHeight);//Input leg 2

    canvas.drawPath(path, paint);

    path.moveTo(centerX, arcRect.top);
    path.lineTo(centerX, 0); //Output pin
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


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


class Lines extends StatefulWidget {
  const Lines({Key key}) : super(key: key);

  @override
  createState() => _LinesState();
}

class _LinesState extends State<Lines> {
  Offset start;
  Offset end;

  @override
  build(_) => GestureDetector(
    onTap: () => print('t'),
    onPanStart: (details) {
      print(details.localPosition);
      setState(() {
        start = details.localPosition;
        end = null;
      });
    },
    onPanUpdate: (details) {
      setState(() {
        end = details.localPosition;
      });
    },
    child: CustomPaint(
      size: Size.infinite,
      painter: LinesPainter(start, end),
    ),
  );
}

class LinesPainter extends CustomPainter {
  final Offset start, end;

  LinesPainter(this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
    if (start == null || end == null) return;
    canvas.drawLine(
        start,
        end,
        Paint()
          ..strokeWidth = 4
          ..color = Colors.redAccent);
  }

  @override
  bool shouldRepaint(LinesPainter oldDelegate) {
    return oldDelegate.start != start || oldDelegate.end != end;
  }
}



class CustomPainterPractice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: CustomPaint(
          painter: BobRoss(),
        ),
      ),
    );
  }
}

class BobRoss extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint rectPaint = Paint();
    rectPaint.style = PaintingStyle.fill;
    rectPaint.color = Colors.greenAccent;

    canvas.drawRect(
        Rect.fromLTWH(0.0, 0.0, size.width, 50),
        rectPaint
    );


  }

  @override
  bool shouldRepaint(BobRoss oldDelegate) => false;
}