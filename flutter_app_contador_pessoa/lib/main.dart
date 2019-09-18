import 'package:flutter/material.dart';

void main() {


  runApp(MaterialApp(
      title: 'Contador de pessoa',
      home: Home()));

}



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _pessoa = 0;
  String _textInfo = "Bem vindo";

  void _changePessoa(int num){
  setState(() {
    _pessoa +=num;

    if(_pessoa < 0){
      _textInfo = "Mundo invertido?";
    }if(_pessoa > 10){
      _textInfo = "Lotado";
    }if(_pessoa <= 10 && _pessoa >= 0){
      _textInfo = "pode entrar";
    }


  });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/restaurant.jpg",
          fit: BoxFit.cover,
          height: 1080.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pessoas $_pessoa',
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text(
                      '+1',
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                    onPressed: () {
                      _changePessoa(1);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text(
                      '-1',
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                    onPressed: () {
                      _changePessoa(-1);

                    },
                  ),
                ),
              ],
            ),
            Text(
              _textInfo,
              style:
              TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }
}
