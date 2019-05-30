import 'package:flutter/material.dart';

final gridColor = {
  2: Colors.white,
  4: Colors.amberAccent,
  8: Colors.orange,
  16: Colors.deepOrange,
  32: Colors.lightBlue,
  64: Colors.blue,
  128: Colors.amber,
  256: Colors.red,
  512: Colors.yellow,
  1024: Colors.purple,
  2048: Colors.pink
};

AnimationController girdMoveController;
const menuTextStyle =
    TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white);
const numTextStyle =
    TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.brown);
const buttonTextStyle = TextStyle(
    fontSize: 15.0, fontWeight: FontWeight.normal, color: Colors.black);
int score;
