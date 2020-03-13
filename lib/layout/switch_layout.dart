import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:test_web_app/component/push_latch_switch.dart';

class SwitchLayout extends StatefulWidget{

	bool switchState = false;

	List<SwitchInfo> _swithInfo;

	SwitchLayout(this._swithInfo);

	@override
  State<StatefulWidget> createState() {
		return _SwitchLayoutState();
  }
}

class _SwitchLayoutState extends State<SwitchLayout>{
	@override
	Widget build(BuildContext context) {
		return Stack(
			children: widget._swithInfo.map((switchInfo) => toSwitch(switchInfo)).toList(),
		);
	}

}

Widget toSwitch(SwitchInfo switchInfo){
	print("toSwitch $switchInfo");
	return Container(
		child: PushLatchSwitch(switchInfo.globalKey, false,switchInfo.inputPinLocation, (bool value) {
			print("calback $value");
		}),
		width: 80,
		height: 80,
	);
}

class SwitchInfo{

	Point inputPinLocation;

	GlobalKey<PushLatchState> globalKey;

	SwitchInfo(this.inputPinLocation,this.globalKey);

}