import 'package:curso_lecheta/componentes/custom_img.dart';
import 'package:curso_lecheta/pages/dog_page.dart';
import 'package:curso_lecheta/utils/utils.dart';
import 'package:flutter/material.dart';

class Dog {
  String nome;
  String img;

  Dog(this.nome, this.img);
}

class HelloListView extends StatefulWidget {
  HelloListViewState createState() => HelloListViewState();
}

class HelloListViewState extends State<HelloListView> {
  bool _gridView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List View"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              setState(() {
                _gridView = false;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.grid_on),
            onPressed: () {
              setState(() {
                _gridView = true;
              });
            },
          ),
        ],
      ),
      body: pageView(),
    );
  }

  pageView() {
    final List<Dog> dogs = [
      Dog("Atila", "atila.jpg"),
      Dog("ingresso", "ingresso.png"),
      Dog("logo", "logo.png"),
      Dog("pizza", "pizza.jpg"),
      Dog("print", "print.png"),
      Dog("logo", "logo.png"),
      Dog("pizza", "pizza.jpg"),
      Dog("print", "print.png"),
      Dog("logo", "logo.png"),
      Dog("pizza", "pizza.jpg"),
      Dog("print", "print.png"),
      Dog("logo", "logo.png"),
      Dog("pizza", "pizza.jpg"),
      Dog("print", "print.png"),
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridView ? 2 : 1,
      ),
      itemCount: dogs.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            push(context, DogPage(dogs[index]));
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _img((dogs[index].img)),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(16)),
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(12),
                  child: Text(
                    dogs[index].nome,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _img(String img) {
    return CustomImg(img);
  }
}
