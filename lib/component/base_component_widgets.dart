import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class BaseComponentStatefulWidget extends StatefulWidget {
  ComponentLocationDetails _componentLocationDetails = ComponentLocationDetails();

  BaseComponentStatefulWidget(Key key) : super(key: key);

  @override
  State<BaseComponentStatefulWidget> createState();

  ComponentLocationDetails get componentLocationDetails => _componentLocationDetails;

  set componentLocationDetails(ComponentLocationDetails componentLocationDetails) {
    this._componentLocationDetails = componentLocationDetails;
  }
}

abstract class BaseComponentState extends State<BaseComponentStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.0),
      child: CustomPaint(
        painter: getPainter(),
      ),
    );
  }

  BaseComponentPainter getPainter();
}

abstract class BaseComponentPainter extends CustomPainter {
  static const PADDING = 10.0;

  BaseComponentStatefulWidget _widget;

  BaseComponentPainter(BaseComponentStatefulWidget _widget) {
    this._widget = _widget;
  }

  ComponentLocationDetails get componentLocationDetails => _widget.componentLocationDetails;

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
