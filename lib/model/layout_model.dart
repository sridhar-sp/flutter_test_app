import 'dart:convert';

import 'package:flutter/foundation.dart';

class Layout{

  String globalKey ;
  int gateType;
  List<OutputMap> outputMapList = List();

  Layout(this.globalKey,this.gateType);

  static void fromJson(@required String json){

    List<Layout> output = List();

    List<dynamic> layoutList = jsonDecode(json);
    for(int i=0, SIZE=layoutList.length;i<SIZE;i++){
      var currentItem = layoutList[i];
      Layout layout = Layout(currentItem["global_key"],currentItem["gate_type"]);

      List<dynamic> outputMapList = currentItem["output_map"];
      for(int j=0,MAP_SIZE=outputMapList.length;j<MAP_SIZE;j++){
        var outputMap = outputMapList[j];
        layout.outputMapList.add(OutputMap(outputMap["global_key"], outputMap["input"]));
      }

      output.add(layout);
    }

    print("Parsed Layout Json Input ${output}");
  }

  @override
  String toString() {
    return "\nglobalKey = $globalKey\ngateType = $gateType\noutputMap $outputMapList";
  }
}

class OutputMap{
  String globalKey ;
  int input;

  OutputMap(this.globalKey,this.input);

  @override
  String toString() {
    return "globalKey = $globalKey input $input";
  }
}

class L{
  final A=0;
}

enum LogicGateType{
  AND,
  OR,
  NOT,
  NAND,
  NOR,
  EXOR,
  EXNOR
}