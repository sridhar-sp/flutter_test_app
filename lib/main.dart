import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_web_app/component/and_gate.dart';
import 'package:test_web_app/component/nand_gate.dart';
import 'package:test_web_app/component/base_component_widgets.dart';
import 'package:test_web_app/layout/pcb_layout.dart';
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
  List<List<Component>> _layoutComponentList;

  Map<String, GlobalKey<BaseComponentState>> _globalListCache = Map();

  List<PointPair> _pcbLayoutConnectionsPairList = List();

  @override
  void initState() {
    super.initState();

    _layoutComponentList = Component.fromJson(jsonInput);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      drawCircuitConnections();
    });
  }

  void drawCircuitConnections() {
    print("++++++== globalListCache == $_globalListCache");

    List<PointPair> connectionsPointPairList = List();

    _layoutComponentList.forEach((componentsInRow) {
      componentsInRow.forEach((component) {
        GlobalKey<BaseComponentState> outputComponentKey = _globalListCache[component.globalKey];

        List<OutputMap> outputMapList = component.outputMapList;
        outputMapList.forEach((outputMappingDetails) {
          print(
              "${component.globalKey} output should connect to the input pin ${outputMappingDetails.input} of ${outputMappingDetails.globalKey} ");

          //Todo   validate the global key present in the cache or not.
          GlobalKey<BaseComponentState> inputComponentKey = _globalListCache[outputMappingDetails.globalKey];

          connectionsPointPairList.add(PointPair(findPinLocation(outputComponentKey, false),
              findPinLocation(inputComponentKey, true, inputPinIndex: outputMappingDetails.input)));
        });

        setState(() {
          _pcbLayoutConnectionsPairList = connectionsPointPairList;
        });
      });
    });
  }

  Point findPinLocation(GlobalKey<BaseComponentState> key, bool isInput, {int inputPinIndex}) {
    ComponentLocationDetails locationDetails = key.currentState.componentLocationDetails;

    RenderBox renderBox = key.currentContext.findRenderObject();
    Offset componentOffset = renderBox.localToGlobal(Offset.zero);

    if (isInput) {
      inputPinIndex+=-1;/// {@link locationDetails#inputLocation} is zero based index.
      if (inputPinIndex >= locationDetails.inputLocation.length) throw ArgumentError("Invalid input pin index");
      return Point(componentOffset.dx + locationDetails.inputLocation[inputPinIndex].x,
          componentOffset.dy + locationDetails.inputLocation[inputPinIndex].y);
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
            RaisedButton(
              child: Text("HI"),
            ),
            PCBLayout(_pcbLayoutConnectionsPairList),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 50),
              child: Container(
                child: constructLayoutFromJson(),
              ),
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
        children: _layoutComponentList.map((e) => getRowForLayout(e)).toList());
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
    _globalListCache[layout.globalKey] = key;
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
