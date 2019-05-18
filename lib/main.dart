import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as prefix0;
import 'package:flutter_2048/grid.dart';
import 'package:flutter_2048/tmpGrid.dart';
import 'package:flutter_2048/utils.dart';

void main() => runApp(MyApp());

class Data {
  int value = 0;
  Animation left;
  Animation top;

  Data(this.value, this.left, this.top);
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
      ),
      home: MyHomePage(title: '2048'),
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
  int durationMillionSecond = 100;
  var gridLeftPositionList = new List<double>();
  var gridTopPositionList = new List<double>();
  final String title;
  var dataMatrix = new List<List<Data>>();

  void resetDataList() {
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
            .animate(gridMoveController);
        widget.dataMatrix[i][j].top = new Tween(
                begin: widget.gridTopPositionList[i],
                end: widget.gridTopPositionList[i])
            .animate(gridMoveController);
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
                .animate(gridMoveController),
            new Tween(
                    begin: widget.gridTopPositionList[i],
                    end: widget.gridTopPositionList[i])
                .animate(gridMoveController)));
      }
    }
  }

  AnimationController gridMoveController;
  prefix0.AnimationController gridMergeController;

  void getNewController() {
    gridMoveController = new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.durationMillionSecond));
    gridMergeController = new AnimationController(
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

  @override
  void initState() {
    super.initState();
    gridMoveController = new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.durationMillionSecond));
    gridMergeController = new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.durationMillionSecond));
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
          print('$i,$j');
        }
      }
    }
    print('--------');
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
    initDataMatrix();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
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
              moveRight();
              getNewController();
            } else {
              print('left');
              moveLeft();
              getNewController();
            }
          },
          onVerticalDragEnd: (DragEndDetails details) {
//                print();
            if (details.primaryVelocity < 0) {
              print('up');
              moveUp();
              getNewController();
            } else {
              print('down');
              moveDown();
              getNewController();
            }
          },
        ),
      ),
      bottomNavigationBar: prefix0.Wrap(
        alignment: prefix0.WrapAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              widget.resetDataList();
              setState(() {});
            },
            child: Text("RESET"),
          ),
          FlatButton(
            onPressed: () {
              moveUp();
              getNewController();
            },
            child: Text("UP"),
          ),
          FlatButton(
            onPressed: () {
              moveDown();
              getNewController();
            },
            child: Text("DOWN"),
          ),
          FlatButton(
            onPressed: () {
              moveLeft();
              getNewController();
            },
            child: Text("LEFT"),
          ),
          FlatButton(
            onPressed: () {
              moveRight();
              getNewController();
            },
            child: Text("RIGHT"),
          ),
        ],
      ),
    );
  }

  Future<Null> playAnimation() async {
    await gridMoveController.forward().orCancel;
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

  void moveUp() {
    var distanceMatrix = getMoveUpDistance(widget.dataMatrix);
    double moveUnit = widget.gridWidth + widget.spaceBetweenGridDistance;
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].top = new Tween(
                begin: widget.dataMatrix[i][j].top.value,
                end: widget.dataMatrix[i][j].top.value -
                    moveUnit * distanceMatrix[i][j])
            .animate(gridMoveController)
              ..addListener(() {
                setState(() {});
              });
      }
    }
    widget.dataMatrix[0][0].top.addStatusListener((status) {
      if (status == prefix0.AnimationStatus.completed) {
        widget.dataMatrix =
            getMovedUpGridMatrix(distanceMatrix, widget.dataMatrix);
        updateDataListPosition();
        setState(() {});
//        printDataMatrix();
//        print('++++++++++++++');
        mergeUp();
      }
    });
    gridMoveController.forward();
  }

  void mergeUp() {
    var distanceMatrix = getMoveUpMergeDistance(widget.dataMatrix);
    double moveUnit = widget.gridWidth + widget.spaceBetweenGridDistance;
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].top = new Tween(
                begin: widget.dataMatrix[i][j].top.value,
                end: widget.dataMatrix[i][j].top.value -
                    moveUnit * distanceMatrix[i][j])
            .animate(gridMergeController)
              ..addListener(() {
                setState(() {});
              });
      }
    }
    widget.dataMatrix[0][0].top.addStatusListener((status) {
      if (status == prefix0.AnimationStatus.completed) {
        widget.dataMatrix =
            getMovedUpMergedGridMatrix(distanceMatrix, widget.dataMatrix);
//        printDataMatrix();
//        print('++++++++++++++');
        updateDataListPosition();
        getNewTwo();
        setState(() {});
//        printDataMatrix();
//        print('++++++++++++++');
      }
    });
    gridMergeController.forward();
  }

  void moveDown() {
    var distanceMatrix = getMoveDownDistance(widget.dataMatrix);
    double moveUnit = widget.gridWidth + widget.spaceBetweenGridDistance;
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].top = new Tween(
                begin: widget.dataMatrix[i][j].top.value,
                end: widget.dataMatrix[i][j].top.value +
                    moveUnit * distanceMatrix[i][j])
            .animate(gridMoveController)
              ..addListener(() {
                setState(() {});
              });
      }
    }
    widget.dataMatrix[0][0].top.addStatusListener((status) {
      if (status == prefix0.AnimationStatus.completed) {
        widget.dataMatrix =
            getMovedDownGridMatrix(distanceMatrix, widget.dataMatrix);
        updateDataListPosition();
        setState(() {});
//        printDataMatrix();
//        print('++++++++++++++');
        mergeDown();
      }
    });
    gridMoveController.forward();
  }

  void mergeDown() {
    var distanceMatrix = getMoveDownMergeDistance(widget.dataMatrix);
    double moveUnit = widget.gridWidth + widget.spaceBetweenGridDistance;
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].top = new Tween(
                begin: widget.dataMatrix[i][j].top.value,
                end: widget.dataMatrix[i][j].top.value +
                    moveUnit * distanceMatrix[i][j])
            .animate(gridMergeController)
              ..addListener(() {
                setState(() {});
              });
      }
    }
    widget.dataMatrix[0][0].top.addStatusListener((status) {
      if (status == prefix0.AnimationStatus.completed) {
        widget.dataMatrix =
            getMovedDownMergedGridMatrix(distanceMatrix, widget.dataMatrix);
//        printDataMatrix();
//        print('++++++++++++++');
        updateDataListPosition();
        getNewTwo();
        setState(() {});
//        printDataMatrix();
//        print('++++++++++++++');
      }
    });
    gridMergeController.forward();
  }

  void moveLeft() {
    var distanceMatrix = getMoveLeftDistance(widget.dataMatrix);
    double moveUnit = widget.gridWidth + widget.spaceBetweenGridDistance;
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].left = new Tween(
                begin: widget.dataMatrix[i][j].left.value,
                end: widget.dataMatrix[i][j].left.value -
                    moveUnit * distanceMatrix[i][j])
            .animate(gridMoveController)
              ..addListener(() {
                setState(() {});
              });
      }
    }
    widget.dataMatrix[0][0].top.addStatusListener((status) {
      if (status == prefix0.AnimationStatus.completed) {
        widget.dataMatrix =
            getMovedLeftGridMatrix(distanceMatrix, widget.dataMatrix);
        updateDataListPosition();
        setState(() {});
//        printDataMatrix();
//        print('++++++++++++++');
        mergeLeft();
      }
    });
    gridMoveController.forward();
  }

  void mergeLeft() {
    var distanceMatrix = getMoveLeftMergeDistance(widget.dataMatrix);
    printMatrix(distanceMatrix);
    double moveUnit = widget.gridWidth + widget.spaceBetweenGridDistance;
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].left = new Tween(
                begin: widget.dataMatrix[i][j].left.value,
                end: widget.dataMatrix[i][j].left.value -
                    moveUnit * distanceMatrix[i][j])
            .animate(gridMergeController)
              ..addListener(() {
                setState(() {});
              });
      }
    }
    widget.dataMatrix[0][0].left.addStatusListener((status) {
      if (status == prefix0.AnimationStatus.completed) {
        widget.dataMatrix =
            getMovedLeftMergedGridMatrix(distanceMatrix, widget.dataMatrix);
//        printDataMatrix();
//        print('++++++++++++++');
        updateDataListPosition();
        getNewTwo();
        setState(() {});
//        printDataMatrix();
//        print('++++++++++++++');
      }
    });
    gridMergeController.forward();
  }

  void moveRight() {
    var distanceMatrix = getMoveRightDistance(widget.dataMatrix);
    double moveUnit = widget.gridWidth + widget.spaceBetweenGridDistance;
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].left = new Tween(
                begin: widget.dataMatrix[i][j].left.value,
                end: widget.dataMatrix[i][j].left.value +
                    moveUnit * distanceMatrix[i][j])
            .animate(gridMoveController)
              ..addListener(() {
                setState(() {});
              });
      }
    }
    widget.dataMatrix[0][0].top.addStatusListener((status) {
      if (status == prefix0.AnimationStatus.completed) {
        widget.dataMatrix =
            getMovedRightGridMatrix(distanceMatrix, widget.dataMatrix);
        updateDataListPosition();
        setState(() {});
//        printDataMatrix();
//        print('++++++++++++++');
        mergeRight();
      }
    });
    gridMoveController.forward();
  }

  void mergeRight() {
    var distanceMatrix = getMoveRightMergeDistance(widget.dataMatrix);
    printMatrix(distanceMatrix);
    double moveUnit = widget.gridWidth + widget.spaceBetweenGridDistance;
    for (int i = 0; i < widget.dataMatrix.length; i++) {
      for (int j = 0; j < widget.dataMatrix[i].length; j++) {
        widget.dataMatrix[i][j].left = new Tween(
                begin: widget.dataMatrix[i][j].left.value,
                end: widget.dataMatrix[i][j].left.value +
                    moveUnit * distanceMatrix[i][j])
            .animate(gridMergeController)
              ..addListener(() {
                setState(() {});
              });
      }
    }
    widget.dataMatrix[0][0].left.addStatusListener((status) {
      if (status == prefix0.AnimationStatus.completed) {
        widget.dataMatrix =
            getMovedRightMergedGridMatrix(distanceMatrix, widget.dataMatrix);
//        printDataMatrix();
//        print('++++++++++++++');
        updateDataListPosition();
        getNewTwo();
        setState(() {});
//        printDataMatrix();
//        print('++++++++++++++');
      }
    });
    gridMergeController.forward();
  }
}
