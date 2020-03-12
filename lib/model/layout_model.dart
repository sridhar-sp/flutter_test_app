import 'dart:convert';

class Component {
  String globalKey;
  int gateType;
  List<OutputMap> outputMapList = List();

  Component(this.globalKey, this.gateType);

  static List<List<Component>> fromJson(String json) {
    List<List<Component>> output = List();

    List<dynamic> jsonMap = jsonDecode(json);
    for (int columnIndex = 0, columnSize = jsonMap.length; columnIndex < columnSize; columnIndex++) {
      List<Component> layoutRowList = List();

      List<dynamic> rowLayoutList = jsonMap[columnIndex];
      for (int rowIndex = 0, rowSize = rowLayoutList.length; rowIndex < rowSize; rowIndex++) {
        var currentItem = jsonMap[columnIndex][rowIndex];
        Component layout = Component(currentItem["global_key"], currentItem["gate_type"]);

        List<dynamic> outputMapList = currentItem["output_map"];
        for (int j = 0, mapSize = outputMapList.length; j < mapSize; j++) {
          var outputMap = outputMapList[j];
          layout.outputMapList.add(OutputMap(outputMap["global_key"], outputMap["input"]));
        }

        layoutRowList.add(layout);
      }

      output.add(layoutRowList);
    }
//    print("Parsed Layout Json Input ${output}");
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
