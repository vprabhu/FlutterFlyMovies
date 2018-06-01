import 'package:flutter/material.dart';

class DetailsEnterAnimation {

  AnimationController controller;
  final Animation<double> nameCurveAnimation;
  DetailsEnterAnimation(this.controller)
      :nameCurveAnimation = new Tween(begin: 0.0, end: 1.0).animate(
    new CurvedAnimation(
      parent: controller,
      curve: new Interval(
        0.250,
        0.550,
        curve: Curves.decelerate ,
      ),
    ),
  );


}