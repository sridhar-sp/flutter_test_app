import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class BaseComponentStatefulWidget extends StatefulWidget {

  final String text;
  BaseComponentStatefulWidget(Key key,{this.text=""}) : super(key: key);

  @override
  State<BaseComponentStatefulWidget> createState();

}

abstract class BaseComponentState extends State<BaseComponentStatefulWidget> {

  ComponentLocationDetails _componentLocationDetails = ComponentLocationDetails();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.0),
      child: CustomPaint(
        painter: getPainter(),
      ),
    );
  }

  ComponentLocationDetails get componentLocationDetails => _componentLocationDetails;

  set componentLocationDetails(ComponentLocationDetails componentLocationDetails) {
    this._componentLocationDetails = componentLocationDetails;
  }

  BaseComponentPainter getPainter();
}

abstract class BaseComponentPainter extends CustomPainter {

  static const PADDING = 10.0;
  static const INPUT_LEG_HEIGHT = 50;
  static const INPUT_LEG_START_PADDING = 20;

  BaseComponentState _state;

  BaseComponentPainter(BaseComponentState _widget) {
    this._state = _widget;
  }

  void drawKey(Canvas canvas,Size size){

    TextPainter textPainter = TextPainter();

    textPainter.text = TextSpan(text: _state.widget.text,style: TextStyle(color: Colors.red));
    textPainter.textDirection=TextDirection.ltr;
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width/2 - textPainter.size.width/2,size.height/2));
  }

  ComponentLocationDetails get componentLocationDetails => _state.componentLocationDetails;

  Paint getCommonPaint() {
    return Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;
  }
}

class ComponentLocationDetails {
  Point _inputOneLocation;

  Point _inputTwoLocation;

  Point _outputLocation;

  Point get inputOneLocation => _inputOneLocation;

  Point get inputTwoLocation => _inputTwoLocation;

  Point get outputLocation => _outputLocation;

  set inputOneLocation(Point inputOneLocation) {
    this._inputOneLocation = inputOneLocation;
  }

  set inputTwoLocation(Point inputTwoLocation) {
    this._inputTwoLocation = inputTwoLocation;
  }

  set outputLocation(Point outputLocation) {
    this._outputLocation = outputLocation;
  }

  @override
  String toString() {
    return "\n Input-1 $inputOneLocation\nInput 2 $inputTwoLocation\nOutput $outputLocation";
  }
}
