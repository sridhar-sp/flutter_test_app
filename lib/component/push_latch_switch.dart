import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PushLatchSwitch extends StatefulWidget{

	bool isPressed;

	final Function(bool value) _callback;

	final Point _inputPoint;

  PushLatchSwitch(Key key,this.isPressed ,this._inputPoint,this._callback) : super(key:key);

  @override
  State<PushLatchSwitch> createState() {
  	print("PushLathcSwitch createState() ${key}");
    return PushLatchState();
  }
}

class PushLatchState extends State<PushLatchSwitch>{

	@override
  Widget build(BuildContext context) {
		print("PushLatchState build() ${widget.key}");
		return Container(
			padding: EdgeInsets.all(2.0),
			child: GestureDetector(
				child: CustomPaint(
					painter: _PushLatchPainter(widget),
					size: Size(80,80),
					child: Text("AA"),
				),
				onTap: (){
					print("PushLatchState onTap() ${widget.key}");
					setState(() {
						widget.isPressed = !widget.isPressed;
					});
				},
			),
		);
  }

}

class _PushLatchPainter extends CustomPainter{

	PushLatchSwitch _widget;
	_PushLatchPainter(this._widget);

  @override
  void paint(Canvas canvas, Size size) {

  	Paint paint = Paint()
	    ..style = _widget.isPressed?PaintingStyle.fill: PaintingStyle.stroke
	    ..color = Colors.red
	    ..strokeWidth = 2.0;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}