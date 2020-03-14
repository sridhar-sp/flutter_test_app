import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_web_app/component/and_gate.dart';
import 'package:test_web_app/component/nand_gate.dart';
import 'package:test_web_app/component/base_component_widgets.dart';
import 'package:test_web_app/component/push_latch_switch.dart';
import 'package:test_web_app/layout/pcb_layout.dart';
import 'package:test_web_app/layout/switch_layout.dart';
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
  Input _input;

  Map<String, GlobalKey<BaseComponentState>> _logicGatesKeyMap = Map();

  List<PointPair> _pcbLayoutConnectionsPairList = List();

  List<SwitchInfo> _switchInfoList = List();

  @override
  void initState() {
    super.initState();

    _input = toInput(jsonInput);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      drawCircuitConnections();
      drawSwitches();

      setState(() {});
    });
  }


  void drawCircuitConnections() {
    print("++++++== globalListCache == $_logicGatesKeyMap");

    _input.logicGates.forEach((componentsInRow) {
      componentsInRow.forEach((component) {
        GlobalKey<BaseComponentState> outputComponentKey = _logicGatesKeyMap[component.globalKey];

        List<OutputMap> outputMapList = component.outputMapList;
        outputMapList.forEach((outputMappingDetails) {
          print(
              "${component.globalKey} output should connect to the input pin ${outputMappingDetails.input} of ${outputMappingDetails.globalKey} ");

          //Todo   validate the global key present in the cache or not.
          GlobalKey<BaseComponentState> inputComponentKey = _logicGatesKeyMap[outputMappingDetails.globalKey];

          _pcbLayoutConnectionsPairList.add(PointPair(findPinLocation(outputComponentKey, false),
              findPinLocation(inputComponentKey, true, inputPinIndex: outputMappingDetails.input)));
        });
      });
    });
  }

  void drawSwitches(){

    _input.switchDetails.forEach((switchElement) {
      GlobalKey<BaseComponentState> inputComponentKey  =  _logicGatesKeyMap[switchElement.outputMap.globalKey];
      Point inputLocation = findPinLocation(inputComponentKey, true,inputPinIndex: switchElement.outputMap.input);

      print("drawSwitches ${switchElement.globalKey}");
      _switchInfoList.add(SwitchInfo(inputLocation,GlobalKey(),switchElement.globalKey));

    });
  }

  Point findPinLocation(GlobalKey<BaseComponentState> key, bool isInput, {int inputPinIndex}) {
    ComponentLocationDetails locationDetails = key.currentState.componentLocationDetails;

    RenderBox renderBox = key.currentContext.findRenderObject();
    Offset componentOffset = renderBox.localToGlobal(Offset.zero);

    if (isInput) {
      inputPinIndex -= 1;;

      /// {@link locationDetails#inputLocation} is zero based index.
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
    print("*********** build == $_logicGatesKeyMap");

    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            SwitchLayout(_switchInfoList),
            PCBLayout(_pcbLayoutConnectionsPairList),
            IgnorePointer(
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
        children: _input.logicGates.map((e) => getRowForLayout(e)).toList());
  }

  Widget getRowForLayout(List<LogicGate> layoutRow) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: layoutRow.map((e) => getItemForLayout(e)).toList(),
        ));
  }

  Widget getItemForLayout(LogicGate layout) {
    return Container(
      width: BaseComponentStatefulWidget.WIDTH,
      height: BaseComponentStatefulWidget.HEIGHT,
      child: getComponent(layout),
    );
  }

  Widget getComponent(LogicGate layout) {
    GlobalKey<BaseComponentState> key = GlobalKey();
    _logicGatesKeyMap[layout.globalKey] = key;
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
