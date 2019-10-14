import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black, Colors.white, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
    );
  }
}
