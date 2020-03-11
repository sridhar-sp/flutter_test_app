import 'dart:convert';

import 'package:flutter/foundation.dart';

class Layout {
  String globalKey;
  int gateType;
  List<OutputMap> outputMapList = List();

  Layout(this.globalKey, this.gateType);

  static List<List<Layout>> fromJson(@required String json) {
    List<List<Layout>> output = List();

    List<dynamic> jsonMap = jsonDecode(json);
    for (int columnIndex = 0, COLUMN_SIZE = jsonMap.length;
        columnIndex < COLUMN_SIZE;
        columnIndex++) {
      List<Layout> layoutRowList = List();

      List<dynamic> rowLayoutList = jsonMap[columnIndex];
      for (int rowIndex = 0, ROW_SIZE = rowLayoutList.length;
          rowIndex < ROW_SIZE;
          rowIndex++) {
        var currentItem = jsonMap[columnIndex][rowIndex];
        Layout layout =
            Layout(currentItem["global_key"], currentItem["gate_type"]);

        List<dynamic> outputMapList = currentItem["output_map"];
        for (int j = 0, MAP_SIZE = outputMapList.length; j < MAP_SIZE; j++) {
          var outputMap = outputMapList[j];
          layout.outputMapList
              .add(OutputMap(outputMap["global_key"], outputMap["input"]));
        }

        layoutRowList.add(layout);
      }

      output.add(layoutRowList);
    }
    print("Parsed Layout Json Input ${output}");
    return output;
  }

  @override
  String toString() {
    return "\nglobalKey = $globalKey\ngateType = $gateType\noutputMap $outputMapList";
  }
}

class OutputMap {
  String globalKey;
  int input;

  OutputMap(this.globalKey, this.input);

  @override
  String toString() {
    return "globalKey = $globalKey input $input";
  }
}

class LogicGateType {
  static const AND = 1;
  static const OR = 2;
  static const NOT = 3;
  static const NAND = 4;
  static const NOR = 5;
  static const EXOR = 6;
  static const EXNOR = 7;
}
