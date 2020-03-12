import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_web_app/component/and_gate.dart';
import 'package:test_web_app/component/nand_gate.dart';
import 'package:test_web_app/component/base_component_widgets.dart';
import 'package:test_web_app/component/pcb_layout.dart';
import 'package:test_web_app/custom_canvas_painter.dart';
import 'package:test_web_app/mock/mock_input.dart';
import 'package:test_web_app/model/layout_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
      ),
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  List<List<Component>> _layoutList;

  Map<String, GlobalKey<BaseComponentState>> globalListCache = Map();

  GlobalKey<BaseComponentState> tempNandGateKey = GlobalKey();

  List<PointPair> pcbLayoutConnectionsPairList = List();

  double startX = 0.0;
  double startY = 0.0;
  double endX = 0.0;
  double endY = 0.0;

  @override
  void initState() {
    super.initState();

    _layoutList = Component.fromJson(jsonInput);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      drawCircuitConnections();
    });
  }
  
  void drawCircuitConnections() {
    print("++++++== globalListCache == $globalListCache");

    List<PointPair> connectionsPointPairList = List();

    _layoutList.forEach((componentsInRow) {
      componentsInRow.forEach((component) {
        GlobalKey<BaseComponentState> outputComponentKey = globalListCache[component.globalKey];

        List<OutputMap> outputMapList = component.outputMapList;
        outputMapList.forEach((element) {
          print(
              "${component.globalKey} output should connect to the input pin ${element.input} of ${element.globalKey} ");

          //Todo   validate the global key present in the cache or not.
          GlobalKey<BaseComponentState> inputComponentKey = globalListCache[element.globalKey];

          connectionsPointPairList.add(PointPair(findPinLocation(outputComponentKey, false),
              findPinLocation(inputComponentKey, true, inputPinIndex: element.input)));
        });

        setState(() {
          pcbLayoutConnectionsPairList = connectionsPointPairList;
        });
      });
    });
  }

  Point findPinLocation(GlobalKey<BaseComponentState> key, bool isInput, {int inputPinIndex}) {
    ComponentLocationDetails locationDetails = key.currentState.componentLocationDetails;

    RenderBox renderBox = key.currentContext.findRenderObject();
    Offset componentOffset = renderBox.localToGlobal(Offset.zero);

    if (isInput) {
      if (inputPinIndex == 1) {
        return Point(componentOffset.dx + locationDetails.inputOneLocation.x,
            componentOffset.dy + locationDetails.inputOneLocation.y);
      } else if (inputPinIndex == 2) {
        return Point(componentOffset.dx + locationDetails.inputTwoLocation.x,
            componentOffset.dy + locationDetails.inputTwoLocation.y);
      } else
        throw ArgumentError("Invalid input pin index");
    } else {
      return Point(
          componentOffset.dx + locationDetails.outputLocation.x, componentOffset.dy + locationDetails.outputLocation.y);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            PCBLayoutWidget(startX, startY, endX, endY),
            PCBLayout(pcbLayoutConnectionsPairList),
            Container(
              child: constructLayoutFromJson(),
            ),
          ],
        ),
      ),
    );
  }

  Column constructLayoutFromJson() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _layoutList.map((e) => getRowForLayout(e)).toList());
  }

  Widget getRowForLayout(List<Component> layoutRow) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: layoutRow.map((e) => getItemForLayout(e)).toList(),
        ));
  }

  Widget getItemForLayout(Component layout) {
    return Container(
      width: 150,
      height: 150,
      child: getComponent(layout),
    );
  }

  Widget getComponent(Component layout) {
    GlobalKey<BaseComponentState> key = GlobalKey();
    globalListCache[layout.globalKey] = key;
    switch (layout.gateType) {
      case LogicGateType.AND:
        return AndGate(key, layout.globalKey);
      case LogicGateType.NAND:
        return NandGate(key, layout.globalKey);
      default:
        throw AssertionError("Invalid gate type ${layout.gateType}");
    }
  }
}
