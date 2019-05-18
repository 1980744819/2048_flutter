import 'package:flutter/widgets.dart';

import 'conf.dart';

// ignore: must_be_immutable
class TmpGrid extends StatefulWidget {
  int value;
  AnimationController controller;
  Animation left;
  Animation top;
  double width;
  double circular;

  TmpGrid(this.value, this.width, double left, double top, this.controller) {
    this.left = new Tween(begin: left, end: left).animate(this.controller);
    this.top = new Tween(begin: top, end: top).animate(this.controller);
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TmpGrid();
  }
}

class _TmpGrid extends State<TmpGrid> {
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
      left: widget.left.value,
      top: widget.top.value,
      child: Container(
        height: widget.width,
        width: widget.width,
        decoration: BoxDecoration(
            color: gridColor[widget.value],
            borderRadius: BorderRadius.all(Radius.circular(widget.circular))),
        child: Center(child: Text(getText())),
      ),
    );
  }
}
