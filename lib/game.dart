import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'grid.dart';

class Data {
  int value = 0;
  Animation left;
  Animation top;

  Data(this.value, this.left, this.top);
}

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

class _MyGame extends State<MyGame> with TickerProviderStateMixin{
  List<List<Data>> dataMatrix;
  var gridLeftPositionList = new List<double>();
  var gridTopPositionList = new List<double>();
  double spaceBetweenGridDistance;
  double containerWidth;
  double gridWidth;
  AnimationController controller;
  int durationMillionSecond;

  _MyGame() {
    containerWidth = widget.width;
    spaceBetweenGridDistance = containerWidth / 60;
    gridWidth = (containerWidth - spaceBetweenGridDistance * 5) / 4;
    gridLeftPositionList = getPositions();
    gridTopPositionList = getPositions();
    durationMillionSecond = 75;
  }

  List<double> getPositions() {
    var tmp = new List<double>();
    tmp.add(spaceBetweenGridDistance);
    for (int i = 1; i < 4; i++) {
      tmp.add(widget.width + spaceBetweenGridDistance + tmp[i - 1]);
    }
    return tmp;
  }

  List<List<Data>> getInitDataMatrix() {
    var tmp = new List<List<Data>>();
    for (int i = 0; i < 4; i++) {
      tmp.add(new List<Data>());
      for (int j = 0; j < 4; j++) {
        int tmpVal = Random.secure().nextBool() == true ? 0 : 2;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
    );
  }
}
