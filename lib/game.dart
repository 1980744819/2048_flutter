import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_2048/utils.dart';

import 'data.dart';
import 'grid.dart';

// ignore: must_be_immutable
class MyGame extends StatefulWidget {
  double width;
  double height;

  MyGame(this.width, this.height);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyGame();
  }
}

class _MyGame extends State<MyGame> with TickerProviderStateMixin {
  List<List<Data>> dataMatrix;
  var gridLeftPositionList = new List<double>();
  var gridTopPositionList = new List<double>();
  double spaceBetweenGridDistance;
  double containerWidth;
  double gridWidth;
  AnimationController controller;
  int durationMillionSecond;
  bool playAnimationFlag;

  List<double> getPositions() {
    var tmp = new List<double>();
    tmp.add(spaceBetweenGridDistance);
    for (int i = 1; i < 4; i++) {
      tmp.add(gridWidth + spaceBetweenGridDistance + tmp[i - 1]);
    }
    return tmp;
  }

  List<List<Data>> getInitDataMatrix() {
    var tmp = new List<List<Data>>();
    for (int i = 0; i < 4; i++) {
      tmp.add(new List<Data>());
      for (int j = 0; j < 4; j++) {
        int tmpVal = Random.secure().nextBool() == true ? 0 : 2;
        print(tmpVal);
        tmp[i].add(Data(
            tmpVal,
            new Tween(
                    begin: gridLeftPositionList[j],
                    end: gridLeftPositionList[j])
                .animate(controller),
            new Tween(
                    begin: gridTopPositionList[i], end: gridTopPositionList[i])
                .animate(controller)));
      }
    }
    print("+++++");
    return tmp;
  }

  List<Grid> getMat() {
    var tmp = new List<Grid>();
    for (int i = 0; i < dataMatrix.length; i++) {
      for (int j = 0; j < dataMatrix[i].length; j++) {
        tmp.add(new Grid(
          dataMatrix[i][j].value,
          gridWidth,
          dataMatrix[i][j].left.value,
          dataMatrix[i][j].top.value,
        ));
      }
    }
    return tmp;
  }

  @override
  void initState() {
    // TODO: implement initState
    containerWidth = widget.width;
    spaceBetweenGridDistance = containerWidth / 60;
    gridWidth = (containerWidth - spaceBetweenGridDistance * 5) / 4;
    gridLeftPositionList = getPositions();
    gridTopPositionList = getPositions();
    durationMillionSecond = 75;
    super.initState();
  }

  AnimationController getController() {
    return new AnimationController(
        vsync: this, duration: Duration(milliseconds: durationMillionSecond));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    controller = getController();
    dataMatrix = getInitDataMatrix();
    return GestureDetector(
      child: Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey,
        child: Stack(
          children: getMat(),
        ),
      ),
      onHorizontalDragEnd: (DragEndDetails details) {},
      onVerticalDragEnd: (DragEndDetails details) {},
    );
  }

  void updateDataMatrixPosition() {
    for (int i = 0; i < dataMatrix.length; i++) {
      for (int j = 0; j < dataMatrix[i].length; j++) {
        dataMatrix[i][j].left = new Tween(
                begin: gridLeftPositionList[j], end: gridLeftPositionList[j])
            .animate(controller);
        dataMatrix[i][j].top = new Tween(
                begin: gridTopPositionList[i], end: gridTopPositionList[i])
            .animate(controller);
      }
    }
  }
  void up()async{
    moveUp();
    controller=getController();
    await controller.forward().orCancel;
    mergeUp();
    controller=getController();
    await controller.forward().orCancel;
  }

  void moveUp() {
    var distanceMatrix = getMoveUpDistance(dataMatrix);
    double moveUnit = gridWidth + spaceBetweenGridDistance;
    for (int i = 0; i < dataMatrix.length; i++) {
      for (int j = 0; j < dataMatrix[i].length; j++) {
        dataMatrix[i][j].top = new Tween(
                begin: dataMatrix[i][j].top.value,
                end: dataMatrix[i][j].top.value -
                    moveUnit * distanceMatrix[i][j])
            .animate(controller)
              ..addListener(() {
                setState(() {});
              });
      }
    }
//    dataMatrix[0][0].top.addStatusListener((status) {
//      if (status == AnimationStatus.completed) {
//        dataMatrix = getMovedUpGridMatrix(distanceMatrix, dataMatrix);
//        updateDataMatrixPosition();
//        setState(() {});
////        mergeUp();
//      }
//    });
  }
  void mergeUp() {
    var distanceMatrix = getMoveUpMergeDistance(dataMatrix);
    double moveUnit = gridWidth + spaceBetweenGridDistance;
    for (int i = 0; i < dataMatrix.length; i++) {
      for (int j = 0; j < dataMatrix[i].length; j++) {
        dataMatrix[i][j].top = new Tween(
            begin: dataMatrix[i][j].top.value,
            end: dataMatrix[i][j].top.value -
                moveUnit * distanceMatrix[i][j])
            .animate(controller)
          ..addListener(() {
            setState(() {});
          });
      }
    }
//    widget.dataMatrix[0][0].top.addStatusListener((status) {
//      if (status == prefix0.AnimationStatus.completed) {
//        widget.dataMatrix =
//            getMovedUpMergedGridMatrix(distanceMatrix, widget.dataMatrix);
//        updateDataListPosition();
//        getNewTwo();
//        setState(() {});
//      }
//    });
//    playAnimation(gridMergeController);
  }
}
