import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _peso = TextEditingController();
  TextEditingController _altura = TextEditingController();

  FocusNode focusNodePeso = FocusNode();
  FocusNode focusNodeAltura = FocusNode();

  GlobalKey<FormState> key = GlobalKey();

  String _info = "Informe seus dados";

  void calcular() {
    double peso = double.parse(_peso.text);
    double altura = double.parse(_altura.text) / 100;
    double imc = peso / (2 * altura);

    if (imc < 18.6) {
      _info = "Abaixo do PESO (${imc.toStringAsPrecision(4)})";
    }
    if (imc >= 18.6 && imc < 24.9) {
      _info = "PESO  Ideal(${imc.toStringAsPrecision(4)})";
    }
    if (imc >= 24.9 && imc < 29.9) {
      _info = "Levemente acima do PESO (${imc.toStringAsPrecision(4)})";
    }
    if (imc >= 29.9 && imc < 34.9) {
      _info = "Obesidade grau I (${imc.toStringAsPrecision(4)})";
    }
    if (imc >= 34.9 && imc < 39.9) {
      _info = "Obesidade grau Ii (${imc.toStringAsPrecision(4)})";
    }
    if (imc > 40.9) {
      _info = "Obesidade grau III(${imc.toStringAsPrecision(4)})";
    }

    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _reset() {
    _peso.text = "";
    _altura.text = "";
    _info = "Informe seus dados";
    key = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora IMC'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _reset();
              });
            },
          )
        ],
      ),
      backgroundColor: Colors.lightGreenAccent,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.person_outline, size: 120.0, color: Colors.white),
              TextFormField(
                onEditingComplete: (){
                  FocusScope.of(context).requestFocus(focusNodeAltura);
                },
                focusNode: focusNodePeso,
                maxLength: 3,
                controller: _peso,
                validator: (value) {
                  if (!value.isEmpty) {
                    if (double.parse(value) > 300 || double.parse(value) < 0) {
                      return "insira um peso valido";
                    }
                  } else {
                    return "insira o peso";
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: 25.0),
                    labelText: 'PESO KG',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25.0),
              ),
              TextFormField(
                focusNode: focusNodeAltura,
                maxLength: 3,
                controller: _altura,
                validator: (value) {
                  if (!value.isEmpty) {
                    if (double.parse(value) > 250 || double.parse(value) < 0) {
                      return "insira uma altura valida";
                    }
                  } else {
                    return "insira a altura";
                  }
                },
                decoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: 25.0),
                    labelText: 'ALTURA CM',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25.0),
              ),
              Container(
                  height: 50.0,
                  child: RaisedButton(
                    color: Colors.green,
                    onPressed: () {
                      if (key.currentState.validate()) {
                        setState(() {
                          calcular();
                        });
                      }
                    },
                    child: Text(
                      'Calcular',
                      style: TextStyle(fontSize: 25.0, color: Colors.white),
                    ),
                  )),
              Text(
                _info,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
