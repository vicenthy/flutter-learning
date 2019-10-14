import 'package:flutter/material.dart';

class GradientContainerDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
    );
  }
}
