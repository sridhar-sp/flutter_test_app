import 'package:flutter/material.dart';

class PushLatchSwitch extends StatefulWidget{

	final bool isPressed;

	final Function(GlobalKey<PushLatchState> key,bool value) _callback;

  PushLatchSwitch(Key key,this.isPressed ,this._callback) : super(key:key);

  @override
  State<PushLatchSwitch> createState() {
  	print("PushLathcSwitch createState() $key");
    return PushLatchState();
  }
}

class PushLatchState extends State<PushLatchSwitch>{
	@override
  Widget build(BuildContext context) {
		print("PushLatchState build() ${widget.key}");
		return Container(
			child: GestureDetector(
				child: CustomPaint(
					painter: _PushLatchPainter(widget),
					size: Size(80,80),
					child: Center(
						child: Text(widget.isPressed?"1":"0"),
					),
				),
				onTap: (){
					widget._callback(widget.key,widget.isPressed);
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