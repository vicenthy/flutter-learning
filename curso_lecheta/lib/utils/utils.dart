import 'package:flutter/material.dart';

Future push(BuildContext context, Widget widget) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (BuildContext context) {
      return widget;
    }),
  );
}

bool pop(BuildContext context, [retorno]) {
  return Navigator.pop(context, retorno);
}
