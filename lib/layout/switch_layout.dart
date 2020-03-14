import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:test_web_app/component/push_latch_switch.dart';

class SwitchLayout extends StatefulWidget {

	static const SWITCH_WIDTH = 40.0;
	static const SWITCH_HEIGHT = 40.0;

  bool switchState = false;

  List<SwitchInfo> _swithInfo;

  SwitchLayout(this._swithInfo);

  @override
  State<StatefulWidget> createState() {
    return _SwitchLayoutState();
  }
}

class _SwitchLayoutState extends State<SwitchLayout> {
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
      children: widget._swithInfo.map((switchInfo) => toSwitch(switchInfo)).toList(),
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
      positionChild(switchInfo.id, Offset(switchInfo.inputPinLocation.x-(SwitchLayout.SWITCH_WIDTH/2),
		      switchInfo.inputPinLocation.y));
    });
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}

Widget toSwitch(SwitchInfo switchInfo) {
  print("toSwitch ${switchInfo.toString()}");
  return LayoutId(
    id: switchInfo.id,
    child: PushLatchSwitch(switchInfo.globalKey, false, switchInfo.inputPinLocation, (bool value) {
      print("calback $value");
    }),
  );
}

class SwitchInfo {
  Point inputPinLocation;

  GlobalKey<PushLatchState> globalKey;

  String id;

  SwitchInfo(this.inputPinLocation, this.globalKey, this.id);
}
