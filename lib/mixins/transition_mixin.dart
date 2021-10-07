import 'package:flutter/material.dart';

abstract class TransitionMixin {
  SlideTransition slideTransition(context, animation, secondaryAnimation, child) {
    Offset begin = Offset(0.0, 1.0);
    Offset end = Offset.zero;
    Curve curve = Curves.ease;

    Animatable<Offset> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
