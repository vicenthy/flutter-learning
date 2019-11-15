import 'package:atila_note/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'config/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atila Note',
      debugShowCheckedModeBanner: false,
      theme: appThemeLight,
      home: HomePage(),
    );
  }
}
