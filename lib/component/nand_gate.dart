import 'package:flutter/material.dart';
import 'package:test_web_app/component/base_component_widgets.dart';
import 'dart:math';

class NandGate extends BaseComponentStatefulWidget {
  NandGate(Key key,String text) : super(key,text:text);

  @override
  State<BaseComponentStatefulWidget> createState() {
    return _NandGateState();
  }
}

class _NandGateState extends BaseComponentState {
  @override
  BaseComponentPainter getPainter() {
    return _NandGatePainter(this);
  }
}

class _NandGatePainter extends BaseComponentPainter {
  _NandGatePainter(_NandGateState state) : super(state);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = getCommonPaint();

    canvas.drawRect(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height), paint); //For testing alone, will remove in release

    double centerX = size.width / 2;
    double centerY = size.height / 2;

    double padding = BaseComponentPainter.PADDING;

    Path path = Path();
    path.moveTo(padding, centerY);
    path.lineTo(size.width - padding, centerY);

    canvas.drawPath(path, paint); //Middle straight line

    final arcRect = Rect.fromLTWH(padding, padding, size.width - padding * 2, size.height / 2);

    path.moveTo(padding, centerY);
    path.lineTo(padding, arcRect.bottom - padding); // Left arc leg

    path.addArc(arcRect, pi, pi); //arc

    path.moveTo(size.width - padding, centerY);
    path.lineTo(size.width - padding, arcRect.height / 2 + padding); //Right arc leg

    canvas.drawPath(path, paint);

    const legStartPadding = BaseComponentPainter.INPUT_LEG_START_PADDING;
    const legHeight = BaseComponentPainter.INPUT_LEG_HEIGHT;

    // Input leg 1
    double inputOneLegX = padding + legStartPadding;
    double inputOneLegY = centerY + legHeight;
    path.moveTo(inputOneLegX, centerY);
    path.lineTo(inputOneLegX, inputOneLegY);

    List<Point> inputLocationDetails = List(2);
    inputLocationDetails[0]=Point(inputOneLegX, inputOneLegY);

    canvas.drawPath(path, paint);

    // Input leg 2
    double inputTwoLegX = size.width - padding - legStartPadding;
    double inputTwoLegY = centerY + legHeight;
    path.moveTo(inputTwoLegX, centerY);
    path.lineTo(inputTwoLegX, inputTwoLegY);

    inputLocationDetails[1]=Point(inputTwoLegX, inputTwoLegY);

    componentLocationDetails.inputLocation = inputLocationDetails;

    canvas.drawPath(path, paint);

    const outputBubbleRadius = 5.0;

    canvas.drawCircle(Offset(centerX, padding - outputBubbleRadius), outputBubbleRadius, getCommonPaint());

    componentLocationDetails.outputLocation = Point(centerX, padding - outputBubbleRadius);

    drawKey(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
