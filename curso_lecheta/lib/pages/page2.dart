import 'package:curso_lecheta/componentes/blue_button.dart';
import 'package:curso_lecheta/utils/utils.dart';
import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page2"),
      ),
      body: Center(
        child: BlueButton("VOLTAR", () => onclickVoltar(context)),
      ),
    );
  }

  onclickVoltar(BuildContext context) {
    pop(context, "PAGE 2");
  }
}
