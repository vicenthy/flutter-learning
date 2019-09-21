import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(title: '', home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _tarefas = [];
  final _tarefaController = TextEditingController();
  Map<String, dynamic> _lastRemoved = Map();
  int _lastIndexRemoveded;

  void _addTarefa() {
    _tarefas.add({"tarefa": _tarefaController.text, "feito": false});
    _saveData();
  }

  @override
  void initState() {
    _readData().then((data) {
      setState(() {
        _tarefas = jsonDecode(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Todo List'),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (enter) {
                        setState(() {
                          _addTarefa();
                          _tarefaController.text = "";
                        });
                      },
                      controller: _tarefaController,
                      decoration: InputDecoration(
                          labelText: 'Nova tarefa',
                          labelStyle: TextStyle(color: Colors.deepPurple),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.deepPurple)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurple))),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _addTarefa();
                          _tarefaController.text = "";
                        });
                      },
                      child: Container(
                        child: Icon(Icons.add),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.deepPurple),
                      )),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: 10.0),
                      itemCount: _tarefas.length,
                      itemBuilder: builItens),
                  onRefresh: atualizar),
            )
          ],
        ));
  }

  Future<File> _saveData() async {
    await Future.delayed(Duration(seconds: 15));
    String data = json.encode(_tarefas);
    final file = await _getFile();
    file.writeAsStringSync(data);
  }

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/data.json");
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (error) {
      return null;
    }
  }

  Widget builItens(BuildContext context, int index) {
    return Dismissible(
      key: Key(UniqueKey().toString()),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_tarefas[index]);
          print(_lastRemoved);
          _lastIndexRemoveded = index;
          _tarefas.removeAt(index);
          _saveData();

          final titulo = _lastRemoved["tarefa"];
          final snackBar = SnackBar(
            content: Text("Tarefa: ${titulo} removida."),
            action: SnackBarAction(
                label: "desfazer",
                onPressed: () {
                  setState(() {
                    _tarefas?.insert(_lastIndexRemoveded, _lastRemoved);
                    _saveData();
                  });
                }),
            duration: Duration(seconds: 2),
          );

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snackBar);
        });
      },
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        onChanged: (isChecked) {
          setState(() {
            _tarefas[index]["feito"] = isChecked;
            _saveData();
          });
        },
        title: Text(_tarefas[index]["tarefa"],
            style: TextStyle(
                decoration: _tarefas[index]["feito"]
                    ? TextDecoration.lineThrough
                    : TextDecoration.none)),
        value: _tarefas[index]["feito"],
        secondary: CircleAvatar(
          child: Icon(_tarefas[index]["feito"] ? Icons.check : Icons.receipt),
        ),
      ),
    );
  }

  Future<Null> atualizar() async {
    setState(() {
      _tarefas.sort((a1, a2) {
        if(a1["feito"] && !a2["feito"]) {
          return 1;
        }if(!a1["feito"] && a2["feito"]) {
          return -1;
        } else {
          return 0;
        }
      });
      _saveData();

    });

    return null;
  }
}
