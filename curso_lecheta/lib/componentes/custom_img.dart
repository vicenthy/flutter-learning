import 'package:flutter/material.dart';

class CustomImg extends StatelessWidget {
  String img;

  CustomImg(this.img);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/$img",
      fit: BoxFit.fill,
    );
  }
}
