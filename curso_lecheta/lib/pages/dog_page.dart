import 'package:curso_lecheta/componentes/custom_img.dart';
import 'package:curso_lecheta/pages/list_view.dart';
import 'package:flutter/material.dart';

class DogPage extends StatelessWidget {
  Dog dog;

  DogPage(this.dog);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dog.nome),
      ),
      body: CustomImg(dog.img),
    );
  }
}
