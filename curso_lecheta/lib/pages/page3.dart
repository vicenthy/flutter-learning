import 'package:curso_lecheta/componentes/blue_button.dart';
import 'package:flutter/material.dart';

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page 3"),
      ),
      body: Center(
        child: BlueButton("VOLTAR", () => onclickVoltar(context)),
      ),
    );
  }

  onclickVoltar(BuildContext context) {
    Navigator.pop(context, "Tela 3");
  }
}
