import 'package:flutter/material.dart';
import 'package:test_web_app/component/base_component_widgets.dart';

class NotGate extends StatelessWidget{

	@override
  StatelessElement createElement() {
    return super.createElement();
  }
	@override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class NotGatePainter extends BaseComponentPainter{

  NotGatePainter(BaseComponentState widget) : super(widget);

	@override
	void paint(Canvas canvas, Size size) {

		Paint paint = getCommonPaint();

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

		Path path = Path();

		const double padding  = BaseComponentPainter.PADDING;

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

	drawKey(canvas, size);
	}

	@override
	bool shouldRepaint(CustomPainter oldDelegate) {
		return false;
	}
}