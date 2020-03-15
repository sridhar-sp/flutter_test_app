import 'dart:convert';

const KEY_LOGIC_GATE_DETAILS = "logic_gate_details";
const KEY_GLOBAL_KEY = "global_key";
const KEY_GATE_TYPE = "gate_type";
const KEY_OUTPUT_MAP = "output_map";
const KEY_INPUT_PIN = "input_pin";
const KEY_SWITCH_DETAILS = "switch_details";

class Input {
  List<List<LogicGate>> _logicGates;

  List<SwitchDetail> _switchDetails;

  Input(this._logicGates, this._switchDetails);

  List<List<LogicGate>> get logicGates => _logicGates;

  List<SwitchDetail> get switchDetails => _switchDetails;

  @override
  String toString() {
    return "LogicGates $_logicGates SwitchDetails $_switchDetails";
  }
}

class LogicGate {
  String globalKey;
  int gateType;
  List<OutputMap> outputMapList = List();

  LogicGate(this.globalKey, this.gateType);

  @override
  String toString() {
    return "globalKey = $globalKey gateType = $gateType outputMap $outputMapList";
  }
}

class SwitchDetail {
  String globalKey;
  OutputMap outputMap;

  SwitchDetail(this.globalKey, this.outputMap);

  @override
  String toString() {
    return "globalKey = $globalKey OutputMap = $outputMap ";
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

Input toInput(String json) {
  List<List<LogicGate>> _logicGates = List();

  List<SwitchDetail> _switchDetails = List();

  var jsonDecodedInput = jsonDecode(json);

  ///Parsing Logic gates details.
  _logicGates = List();

  List<dynamic> gatesDetails = jsonDecodedInput[KEY_LOGIC_GATE_DETAILS];
  for (int columnIndex = 0, columnSize = gatesDetails.length; columnIndex < columnSize; columnIndex++) {
    List<LogicGate> layoutRowList = List();

    List<dynamic> rowLayoutList = gatesDetails[columnIndex];
    for (int rowIndex = 0, rowSize = rowLayoutList.length; rowIndex < rowSize; rowIndex++) {
      var currentItem = gatesDetails[columnIndex][rowIndex];
      LogicGate component = LogicGate(currentItem[KEY_GLOBAL_KEY], currentItem[KEY_GATE_TYPE]);

      List<dynamic> outputMapList = currentItem[KEY_OUTPUT_MAP];
      for (int j = 0, mapSize = outputMapList.length; j < mapSize; j++) {
        var outputMap = outputMapList[j];
        component.outputMapList.add(OutputMap(outputMap[KEY_GLOBAL_KEY], outputMap[KEY_INPUT_PIN]));
      }

      layoutRowList.add(component);
    }
    _logicGates.add(layoutRowList);
  }

  ///Parsing switch details
  List<dynamic> switchDetails = jsonDecodedInput[KEY_SWITCH_DETAILS];
  _switchDetails = List();

  switchDetails.forEach((switchElement) {
    _switchDetails.add(SwitchDetail(switchElement[KEY_GLOBAL_KEY],
        OutputMap(switchElement[KEY_OUTPUT_MAP][KEY_GLOBAL_KEY], switchElement[KEY_OUTPUT_MAP][KEY_INPUT_PIN])));
  });

  return Input(_logicGates, _switchDetails);
}
