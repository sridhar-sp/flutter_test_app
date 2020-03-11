import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Gate extends StatefulWidget {
  @override
  GateState createState() => GateState();
}

class GateState extends State<Gate> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    });
  }

  @override
  Widget build(BuildContext context) {
//    print("GateState "+context.size.toString());
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color:Colors.red)
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("AND",
          style: TextStyle(fontSize: 24),),
      ),
    );
  }
}

class LogicGate extends StatefulWidget{

  final String mName;

  LogicGate(this.mName);

  @override
  LogicGateState createState() {
    return LogicGateState();
  }
}

class LogicGateState extends State<LogicGate>{

  @override
  Widget build(BuildContext context) {
   return Container(
     decoration: BoxDecoration(
       shape: BoxShape.rectangle,
       border: Border.all(color: Colors.red,width: 2.0)
     ),
     child: Padding(
       padding: EdgeInsets.all(8.0),
       child: Text(widget.mName,
       style: TextStyle(fontSize: 24),),
     ),
   );
  }

}
