import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:test_web_app/component/push_latch_switch.dart';

class SwitchLayout extends StatefulWidget {
  static const SWITCH_WIDTH = 55.0;
  static const SWITCH_HEIGHT = 55.0;

  final List<SwitchInfo> _swithInfo;

  SwitchLayout(this._swithInfo);

  @override
  State<StatefulWidget> createState() {
    return _SwitchLayoutState();
  }
}

class _SwitchLayoutState extends State<SwitchLayout> {
  Map<String, bool> switchStateMap = Map();

  _SwitchLayoutDelegate _switchLayoutDelegate;

  @override
  void initState() {
    super.initState();
    _switchLayoutDelegate = _SwitchLayoutDelegate(widget._swithInfo);
  }

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _switchLayoutDelegate,
      children: widget._swithInfo
          .map((switchInfo) =>
              toSwitch(switchInfo, switchStateMap.containsKey(switchInfo.id) && switchStateMap[switchInfo.id],
                  (GlobalKey<PushLatchState> key, bool value) {
                setState(() {
                  switchStateMap[switchInfo.id] = !value;
                });
              }))
          .toList(),
    );
  }
}

class _SwitchLayoutDelegate extends MultiChildLayoutDelegate {
  List<SwitchInfo> _swithInfoList;

  _SwitchLayoutDelegate(this._swithInfoList);

  @override
  void performLayout(Size size) {
    _swithInfoList.forEach((switchInfo) {
      layoutChild(switchInfo.id, BoxConstraints.tight(Size(SwitchLayout.SWITCH_WIDTH, SwitchLayout.SWITCH_HEIGHT)));
      positionChild(switchInfo.id,
          Offset(switchInfo.inputPinLocation.x - (SwitchLayout.SWITCH_WIDTH / 2), switchInfo.inputPinLocation.y));
    });
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}

Widget toSwitch(SwitchInfo switchInfo, bool isPressed, Function(GlobalKey<PushLatchState> key, bool value) callback) {
  print("toSwitch ${switchInfo.toString()}");

  return LayoutId(
    id: switchInfo.id,
    child: PushLatchSwitch(switchInfo.globalKey, isPressed, switchInfo.inputPinLocation, callback),
  );
}

class SwitchInfo {
  Point inputPinLocation;

  GlobalKey<PushLatchState> globalKey;

  String id;

  SwitchInfo(this.inputPinLocation, this.globalKey, this.id);
}
