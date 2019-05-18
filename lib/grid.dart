import 'package:flutter/widgets.dart';
import 'package:flutter_2048/conf.dart';

// ignore: must_be_immutable
class Grid extends StatefulWidget {
  double left = 0;
  double top = 0;
  int value = 0;
  double width = 0;
  double circular = 0;

  Grid(int value, this.width, double left, double top) {
    this.value = value;
    this.left = left;
    this.top = top;
  }

  int getValue() {
    return value;
  }

  double getLeft() {
    return left;
  }

  double getTop() {
    return top;
  }

  void setPosition(double left, double top) {
    this.left = left;
    this.top = top;
  }

  void setValue(int val) {
    this.value = val;
  }

  void setLeft(double left) {
    this.left = left;
  }

  void setTop(double top) {
    this.top = top;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Grid();
  }
}

class _Grid extends State<Grid> {
  String getText() {
    if (widget.value == 0) {
      return '';
    }
    return widget.value.toString();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    widget.circular = widget.width / 10;
    return Positioned(
      left: widget.getLeft(),
      top: widget.getTop(),
      child: Container(
        height: widget.width,
        width: widget.width,
        decoration: BoxDecoration(
            color: gridColor[widget.getValue()],
            borderRadius: BorderRadius.all(Radius.circular(widget.circular))),
        child: Center(child: Text(getText())),
      ),
    );
  }
}
