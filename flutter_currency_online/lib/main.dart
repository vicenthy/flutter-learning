import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart' as async;
import 'dart:convert';

const URL = "https://api.hgbrasil.com/finance?key=29eb6081";

void main() async {
  await getData();
  runApp(MaterialApp(
      title: 'App Currency Online',
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)))),
      home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _realControlador = TextEditingController();
  final _dolarControlador = TextEditingController();
  final _euroControlador = TextEditingController();

  Future<Map> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = getData();
  }

  void _changeReal(String text) {
    if (text.isEmpty) {
      _clearAll();
    }
    double realDigitado = double.parse(replaceVigular(text));
    _dolarControlador.text = (realDigitado / dolar).toStringAsPrecision(2);
    _euroControlador.text = (realDigitado / euro).toStringAsPrecision(2);
  }

  void _changeDolar(String text) {
    if (text.isEmpty) {
      _clearAll();
    }

    double dolarDigitado = double.parse(replaceVigular(text));
    _realControlador.text = (dolarDigitado * dolar).toStringAsPrecision(2);
    _euroControlador.text =
        ((dolarDigitado * dolar) / euro).toStringAsPrecision(2);
  }

  void _changeEuro(String text) {
    if (text.isEmpty) {
      _clearAll();
    }
    double euroDigitado = double.parse(replaceVigular(text));
    _realControlador.text = (euroDigitado * euro).toStringAsPrecision(2);
    _dolarControlador.text =
        ((euroDigitado * euro) / dolar).toStringAsPrecision(2);
  }

  void _clearAll() {
    _realControlador.text = "";
    _dolarControlador.text = "";
    _euroControlador.text = "";
  }

  String replaceVigular(String text) {
    return text.replaceAll(",", ".");
  }

  double dolar = 0;
  double euro = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          actions: <Widget>[
            FlatButton(
              color: Colors.amber,
              child: Text(
                'Atualizar',
                style: TextStyle(color: Colors.red, fontSize: 15.0),
              )
              ,
              onPressed: () {
                FutureBuilder<Map>(
                  future: _futureData,
                  builder: (context, snapshot) {
                    setState(() {
                      _futureData = getData();
                    });
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: getbuilder(context, snapshot),
                    );
                  },
                );
              },
            )
          ],
          backgroundColor: Colors.amber,
          centerTitle: true,
          title: Text('\$ Conversor \$')),
      body: FutureBuilder<Map>(
          future: _futureData,
          builder: (context, snapshot) {
            return getbuilder(context, snapshot);
          }),
    );
  }

  Widget getbuilder(context, snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
      case ConnectionState.none:
        return Center(
            child: new CircularProgressIndicator(
                backgroundColor: Colors.amber,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),
                semanticsLabel: 'Obtentado dados',

            )
        );
      default:
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Erro ao obter os dados :(",
              style: TextStyle(color: Colors.red, fontSize: 25.0),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          dolar = snapshot.data['USD']['buy'];
          euro = snapshot.data['EUR']['buy'];

          return SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                buildTextField("Real", "R\$:", _realControlador, _changeReal),
                buildTextField("Dolar", "\$:", _dolarControlador, _changeDolar),
                buildTextField("Euro", "€:", _euroControlador, _changeEuro)
              ],
            ),
          );
        }
    }
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(URL);
  await new Future.delayed(const Duration(milliseconds: 10000));
  return json.decode(response.body)["results"]["currencies"];
}

Widget buildTextField(String label, String preffix,
    TextEditingController controlador, Function change) {
  return Padding(
    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    child: TextField(
      controller: controlador,
      style: TextStyle(color: Colors.amber, fontSize: 25),
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber),
          focusedBorder: getBorderStyle(),
          border: getBorderStyle(),
          enabledBorder: getBorderStyle(),
          prefixText: preffix,
          prefixStyle: TextStyle(color: Colors.amber, fontSize: 25)),
      onChanged: change,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    ),
  );
}

OutlineInputBorder getBorderStyle() {
  return OutlineInputBorder(borderSide: BorderSide(color: Colors.amber));
}
