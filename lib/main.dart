import 'package:flutter/material.dart';
import 'package:test_web_app/custom_canvas_painter.dart';
import 'package:test_web_app/mock/mock_input.dart';
import 'package:test_web_app/model/layout_model.dart';
import 'package:test_web_app/views.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
      ),
      home: HomeWidget(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class HomeWidget extends StatefulWidget {
  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  GlobalKey<AndGateState> firstLevelAndGateKey = GlobalKey();
  GlobalKey<AndGateState> secondLevelAndGateKey = GlobalKey();

  Map<String, GlobalKey<AndGateState>> globalListCache = Map();

  double startX = 0.0;
  double startY = 0.0;
  double endX = 0.0;
  double endY = 0.0;

  @override
  void initState() {
    super.initState();

    Layout.fromJson(jsonInput);

//    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {afterLayout();});
  }

  void afterLayout() {
    print("PostFrameCallback in HomeWidgetState ");

    RenderBox firstAndGateRO =
        firstLevelAndGateKey.currentContext.findRenderObject();
    RenderBox secondAndGateRO =
        secondLevelAndGateKey.currentContext.findRenderObject();

    Offset firstGateOffset = firstAndGateRO.localToGlobal(Offset.zero);
    Offset secondGateOffset = secondAndGateRO.localToGlobal(Offset.zero);

    setState(() {
      startX = firstGateOffset.dx;
      startY = firstGateOffset.dy;
      endX = secondGateOffset.dx;
      endY = secondGateOffset.dy;
    });

    print("firstAndGateRO size ${firstAndGateRO.size} Pos "
        "${firstAndGateRO.localToGlobal(Offset.zero)}");
  }

  Column constructLayoutFromJson() {
    List<List<Layout>> layoutList = Layout.fromJson(jsonInput);
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: layoutList.map((e) => getRowForLayout(e)).toList());
  }

  Widget getRowForLayout(List<Layout> layoutRow) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: layoutRow.map((e) => getItemForLayout(e)).toList(),
      )
    );
  }

  Widget getItemForLayout(Layout layout) {
    return Container(
      width: 150,
      height: 150,
      child: getLogicGate(layout),
    );
  }

  Widget getLogicGate(Layout layout) {
    GlobalKey<AndGateState> key = GlobalKey();
    globalListCache[layout.globalKey] = key;
    switch (layout.gateType) {
      case LogicGateType.AND:
        return AndGateWidget(key: key);
      default:
        throw AssertionError("Invalid gate type ${layout.gateType}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Lines(),
            PCBLayoutWidget(startX, startY, endX, endY),
            Container(
              child: constructLayoutFromJson(),
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.end,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      LogicGate("AND"),
//                      Container(
//                        width: 150,
//                        height: 150,
//                        child: AndGateWidget(
//                          key: secondLevelAndGateKey,
//                        ),
//                      ),
//                      Container(
//                          width: 150,
//                          height: 150,
//                          child: NotGateWidget(
//                            key: ValueKey("3"),
//                          )),
//                    ],
//                  ),
//                  SizedBox(
//                    height: 56,
//                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Container(
//                        width: 150,
//                        height: 150,
//                        child: AndGateWidget(key: firstLevelAndGateKey),
//                      ),
//                      Container(
//                          width: 150,
//                          height: 150,
//                          child: NotGateWidget(
//                            key: ValueKey("1"),
//                          )),
//                    ],
//                  ),
//                ],
//              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 20,
            ),
            NotGateWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
