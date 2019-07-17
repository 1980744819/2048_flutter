import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as prefix0;
import 'package:flutter_2048/conf.dart';
import 'package:flutter_2048/grid.dart';
import 'package:flutter_2048/tmpGrid.dart';
import 'package:flutter_2048/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data.dart';

//void main() => runApp(MyApp());
void main() {
  runApp(MyApp());
}

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
          primarySwatch: Colors.orange,
          fontFamily: 'StarJedi'),
      home: MyHomePage(title: '2048'),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  double width = 0;
  double height = 0;
  double spaceBetweenGridDistance = 0;
  double containerWidth = 0;
  double gridWidth = 0;
  int durationMillionSecond = 75;
  var gridLeftPositionList = new List<double>();
  var gridTopPositionList = new List<double>();
  final String title;
  var dataMatrix = new List<List<Data>>();
  bool flag;

  void resetDataList() {
    score = 0;
    for (int i = 0; i < dataMatrix.length; i++) {
      for (int j = 0; j < dataMatrix[i].length; j++) {
        dataMatrix[i][j].value = Random.secure().nextBool() == true ? 0 : 2;
      }
    }
  }

  List<double> getPositions() {
    var tmp = new List<double>();
    tmp.add(spaceBetweenGridDistance);
    for (int i = 1; i < 4; i++) {
      tmp.add(gridWidth + spaceBetweenGridDistance + tmp[i - 1]);
    }
    return tmp;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  double getContainerWidth() {
    return widget.width * 0.9;
  }

  void updateDataListPosition() {
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].left = new Tween(
                begin: widget.gridLeftPositionList[j],
                end: widget.gridLeftPositionList[j])
            .animate(controller);
        widget.dataMatrix[i][j].top = new Tween(
                begin: widget.gridTopPositionList[i],
                end: widget.gridTopPositionList[i])
            .animate(controller);
      }
    }
  }

  void initDataMatrix() {
    if (widget.dataMatrix.length != 0) {
      return;
    }
    for (int i = 0; i < 4; i++) {
      widget.dataMatrix.add(new List<Data>());
      for (int j = 0; j < 4; j++) {
        int tmpVal = Random.secure().nextBool() == true ? 0 : 2;
        widget.dataMatrix[i].add(Data(
            tmpVal,
//            gridLeftPositionList[j],
            new Tween(
                    begin: widget.gridLeftPositionList[j],
                    end: widget.gridLeftPositionList[j])
                .animate(controller),
            new Tween(
                    begin: widget.gridTopPositionList[i],
                    end: widget.gridTopPositionList[i])
                .animate(controller)));
      }
    }
  }

  AnimationController controller;
  int highScore;
  SharedPreferences prefs;

  void getNewController() {
    controller = new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.durationMillionSecond));
  }

  List<Grid> getMat() {
    var tmp = new List<Grid>();
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        tmp.add(new Grid(
          widget.dataMatrix[i][j].value,
          widget.gridWidth,
          widget.dataMatrix[i][j].left.value,
          widget.dataMatrix[i][j].top.value,
//            gridMoveController
        ));
      }
    }
    return tmp;
  }

  prefix0.AnimationController getController() {
    return new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.durationMillionSecond));
  }

  @override
  void initState() {
    super.initState();
    controller = getController();
//    setHighScore();
  }

  int count = 0;

  @override
  void dispose() {
    super.dispose();
  }

  bool isGameOver() {
    for (int i = 1; i < widget.dataMatrix.length; i++) {
      for (int j = 1; j < widget.dataMatrix[i].length; j++) {
        if (widget.dataMatrix[i][j].value ==
                widget.dataMatrix[i - 1][j].value ||
            widget.dataMatrix[i][j].value ==
                widget.dataMatrix[i][j - 1].value) {
          return false;
        }
      }
    }
    return true;
  }

  void getNewTwo() {
    var res = new List<int>();
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        if (widget.dataMatrix[i][j].value == 0) {
          res.add(i * widget.dataMatrix.length + j);
//          print('$i,$j');
        }
      }
    }
    if (res.length == 0) {
      if (isGameOver()) {
        widget.resetDataList();
        setState(() {});
      }
      return;
    }
    int index = Random.secure().nextInt(res.length);
    widget
        .dataMatrix[res[index] ~/ widget.dataMatrix.length]
            [res[index] % widget.dataMatrix.length]
        .value = 2;
  }

  setHighScore() async {
//    print(score);
    prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('score') ?? 0;
    if (score > highScore) await prefs.setInt('score', score);
    highScore = prefs.getInt('score') ?? 0;
//    print(highScore);
//    setState(() {});
  }

  Future<String> getHighScore() async {
    prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('score') ?? 0;
    if (score > highScore) await prefs.setInt('score', score);
    highScore = prefs.getInt('score') ?? 0;
    return highScore.toString();
  }

  @override
  Widget build(BuildContext context) {
    widget.width = MediaQuery.of(context).size.width;
    widget.height = MediaQuery.of(context).size.height;
    widget.containerWidth = getContainerWidth();
    widget.spaceBetweenGridDistance = widget.containerWidth / 60;
    widget.gridWidth =
        (widget.containerWidth - widget.spaceBetweenGridDistance * 5) / 4;
    widget.gridLeftPositionList = widget.getPositions();
    widget.gridTopPositionList = widget.getPositions();
    if (widget.flag == null) widget.flag = true;
    initDataMatrix();
    if (score == null) score = 0;
//    setHighScore();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: menuTextStyle,
        ),
      ),
      body: prefix0.Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: prefix0.MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: widget.height / 40,
                    bottom: widget.height / 40,
                    right: widget.width / 20),
                height: widget.height / 15,
                width: widget.width / 4,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  children: <Widget>[Text("score"), Text(score.toString())],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: widget.height / 40,
                    bottom: widget.height / 40,
                    left: widget.width / 20),
                height: widget.height / 15,
                width: widget.width / 4,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  children: <Widget>[
                    Text("best"),
//                    Text(highScore.toString()),
                    FutureBuilder<String>(
                      future: getHighScore(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data);
                        } else
                          return Text('0');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Center(
            child: GestureDetector(
              child: Container(
                height: widget.containerWidth,
                width: widget.containerWidth,
                color: Colors.grey,
                child: Stack(
                  children: getMat(),
                ),
              ),
              onHorizontalDragEnd: (DragEndDetails details) {
                if (details.primaryVelocity > 0) {
                  print('right');
                  right();
                } else {
                  print('left');
                  left();
                }
              },
              onVerticalDragEnd: (DragEndDetails details) {
//                print();
                if (details.primaryVelocity < 0) {
                  print('up');
//              moveUp();
                  up();
                } else {
                  print('down');
                  down();
//              getNewController();
                }
              },
            ),
          ),
//          Column(
//            children: <Widget>[
//              FlatButton(
//                onPressed: () {
//                  up();
//                },
//                child: Icon(Icons.keyboard_arrow_up),
//              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  FlatButton(
//                    onPressed: () {
//                      left();
//                    },
//                    child: Icon(Icons.keyboard_arrow_left),
//                  ),
//                  FlatButton(
//                    onPressed: () {
//                      widget.resetDataList();
//                      setState(() {});
//                    },
//                    child: Icon(Icons.refresh),
//                  ),
//                  FlatButton(
//                    onPressed: () {
//                      right();
//                    },
//                    child: Icon(Icons.keyboard_arrow_right),
//                  ),
//                ],
//              ),
//              FlatButton(
//                onPressed: () {
//                  down();
//                },
//                child: Icon(Icons.keyboard_arrow_down),
//              ),
//            ],
//          )
        ],
      ),
      bottomNavigationBar: prefix0.Wrap(
        alignment: prefix0.WrapAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              widget.resetDataList();
              setState(() {});
            },
            child: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  void printDataMatrix() {
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        print(widget.dataMatrix[i][j].value);
      }
    }
  }

  void printMatrix(List<List<int>> input) {
    for (int i = 0; i < input.length; i++) {
      for (int j = 0; j < input[i].length; j++) {
        print(input[i][j]);
      }
    }
  }

//  var stepMap=Map<String,Map<String,Function>>();

  void up() async {
    if (widget.flag != true) return;
    widget.flag = false;
    controller = getController();
    List<List<int>> distanceMatrix = getMoveUpDistance(widget.dataMatrix);
    moveUp(distanceMatrix);
    await controller.forward().orCancel;
    widget.dataMatrix = getMovedUpGridMatrix(distanceMatrix, widget.dataMatrix);
    updateDataListPosition();
    controller = getController();
    distanceMatrix = getMoveUpMergeDistance(widget.dataMatrix);
    mergeUp(distanceMatrix);
    await controller.forward().orCancel;
    widget.dataMatrix =
        getMovedUpMergedGridMatrix(distanceMatrix, widget.dataMatrix);
    updateDataListPosition();
    getNewTwo();
//    await setHighScore();
    setState(() {});
    widget.flag = true;
  }

  void down() async {
    if (widget.flag != true) return;
    widget.flag = false;
    controller = getController();
    List<List<int>> distanceMatrix = getMoveDownDistance(widget.dataMatrix);
    moveDown(distanceMatrix);
    await controller.forward().orCancel;
    widget.dataMatrix =
        getMovedDownGridMatrix(distanceMatrix, widget.dataMatrix);
    updateDataListPosition();
    controller = getController();
    distanceMatrix = getMoveDownMergeDistance(widget.dataMatrix);
    mergeDown(distanceMatrix);
    await controller.forward().orCancel;
    widget.dataMatrix =
        getMovedDownMergedGridMatrix(distanceMatrix, widget.dataMatrix);
    updateDataListPosition();
    getNewTwo();
    setState(() {});
    widget.flag = true;
  }

  void left() async {
    if (widget.flag != true) return;
    widget.flag = false;
    controller = getController();
    List<List<int>> distanceMatrix = getMoveLeftDistance(widget.dataMatrix);
    moveLeft(distanceMatrix);
    await controller.forward().orCancel;
    widget.dataMatrix =
        getMovedLeftGridMatrix(distanceMatrix, widget.dataMatrix);
    updateDataListPosition();
    controller = getController();
    distanceMatrix = getMoveLeftMergeDistance(widget.dataMatrix);
    mergeLeft(distanceMatrix);
    await controller.forward().orCancel;
    widget.dataMatrix =
        getMovedLeftMergedGridMatrix(distanceMatrix, widget.dataMatrix);
    updateDataListPosition();
    getNewTwo();
    setState(() {});
    widget.flag = true;
  }

  void right() async {
    if (widget.flag != true) return;
    widget.flag = false;
    controller = getController();
    List<List<int>> distanceMatrix = getMoveRightDistance(widget.dataMatrix);
    moveRight(distanceMatrix);
    await controller.forward().orCancel;
    widget.dataMatrix =
        getMovedRightGridMatrix(distanceMatrix, widget.dataMatrix);
    updateDataListPosition();
    controller = getController();
    distanceMatrix = getMoveRightMergeDistance(widget.dataMatrix);
    mergeRight(distanceMatrix);
    await controller.forward().orCancel;
    widget.dataMatrix =
        getMovedRightMergedGridMatrix(distanceMatrix, widget.dataMatrix);
    updateDataListPosition();
    getNewTwo();
    setState(() {});
    widget.flag = true;
  }

  void moveUp(List<List<int>> distanceMatrix) {
    double moveUnit = widget.gridWidth + widget.spaceBetweenGridDistance;
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].top = new Tween(
                begin: widget.dataMatrix[i][j].top.value,
                end: widget.dataMatrix[i][j].top.value -
                    moveUnit * distanceMatrix[i][j])
            .animate(controller)
              ..addListener(() {
                setState(() {});
              });
      }
    }
  }

  void mergeUp(List<List<int>> distanceMatrix) {
    double moveUnit = widget.gridWidth + widget.spaceBetweenGridDistance;
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].top = new Tween(
                begin: widget.dataMatrix[i][j].top.value,
                end: widget.dataMatrix[i][j].top.value -
                    moveUnit * distanceMatrix[i][j])
            .animate(controller)
              ..addListener(() {
                setState(() {});
              });
      }
    }
  }

  void moveDown(List<List<int>> distanceMatrix) {
    double moveUnit = widget.gridWidth + widget.spaceBetweenGridDistance;
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].top = new Tween(
                begin: widget.dataMatrix[i][j].top.value,
                end: widget.dataMatrix[i][j].top.value +
                    moveUnit * distanceMatrix[i][j])
            .animate(controller)
              ..addListener(() {
                setState(() {});
              });
      }
    }
  }

  void mergeDown(List<List<int>> distanceMatrix) {
    double moveUnit = widget.gridWidth + widget.spaceBetweenGridDistance;
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].top = new Tween(
                begin: widget.dataMatrix[i][j].top.value,
                end: widget.dataMatrix[i][j].top.value +
                    moveUnit * distanceMatrix[i][j])
            .animate(controller)
              ..addListener(() {
                setState(() {});
              });
      }
    }
  }

  void moveLeft(List<List<int>> distanceMatrix) {
    double moveUnit = widget.gridWidth + widget.spaceBetweenGridDistance;
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].left = new Tween(
                begin: widget.dataMatrix[i][j].left.value,
                end: widget.dataMatrix[i][j].left.value -
                    moveUnit * distanceMatrix[i][j])
            .animate(controller)
              ..addListener(() {
                setState(() {});
              });
      }
    }
  }

  void mergeLeft(List<List<int>> distanceMatrix) {
    double moveUnit = widget.gridWidth + widget.spaceBetweenGridDistance;
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].left = new Tween(
                begin: widget.dataMatrix[i][j].left.value,
                end: widget.dataMatrix[i][j].left.value -
                    moveUnit * distanceMatrix[i][j])
            .animate(controller)
              ..addListener(() {
                setState(() {});
              });
      }
    }
  }

  void moveRight(List<List<int>> distanceMatrix) {
    double moveUnit = widget.gridWidth + widget.spaceBetweenGridDistance;
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].left = new Tween(
                begin: widget.dataMatrix[i][j].left.value,
                end: widget.dataMatrix[i][j].left.value +
                    moveUnit * distanceMatrix[i][j])
            .animate(controller)
              ..addListener(() {
                setState(() {});
              });
      }
    }
  }

  void mergeRight(List<List<int>> distanceMatrix) {
    double moveUnit = widget.gridWidth + widget.spaceBetweenGridDistance;
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].left = new Tween(
                begin: widget.dataMatrix[i][j].left.value,
                end: widget.dataMatrix[i][j].left.value +
                    moveUnit * distanceMatrix[i][j])
            .animate(controller)
              ..addListener(() {
                setState(() {});
              });
      }
    }
  }
}
