import 'package:atila_note/componentes/my_search_delegate.dart';
import 'package:atila_note/pages/edit_note.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _notesHeight = 0.0;
  bool _isNotesOpen = false;
  int _isGridOrList = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Notas"),
            IconButton(
              onPressed: () {
                setState(() {
                  alterarPastasDeNotas();
                });
              },
              icon: Icon(this._isNotesOpen
                  ? Icons.arrow_drop_up
                  : Icons.arrow_drop_down),
            )
          ],
        ),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.pop(context);
                        if (this._isGridOrList == 1) {
                          this._isGridOrList = 2;
                        } else {
                          this._isGridOrList = 1;
                        }
                      });
                    },
                    child: ListTile(
                      title: Text(this._isGridOrList == 2 ? "Grade" : "Lista"),
                    ),
                  ),
                ),
              ];
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: 45,
            ),
            child: StaggeredGridView.count(
              crossAxisCount: 2,
              children: <Widget>[
                AnimationConfiguration.staggeredGrid(
                  position: 1,
                  duration: Duration(milliseconds: 1000),
                  columnCount: this._isGridOrList,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: InkWell(
                        onTap: () {
                          navegarParaEditNote(
                              context: context, note: 'Exemplo Card 1');
                        },
                        child: Card(
                          margin: EdgeInsets.all(7),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Exemplo Card 1"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimationConfiguration.staggeredGrid(
                  position: 1,
                  duration: Duration(milliseconds: 1000),
                  columnCount: this._isGridOrList,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: InkWell(
                        onTap: () {
                          navegarParaEditNote(
                              context: context, note: 'Exemplo card 2');
                        },
                        child: Card(
                          margin: EdgeInsets.all(3),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Exemplo card 2"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              staggeredTiles: [
                StaggeredTile.fit(this._isGridOrList),
                StaggeredTile.fit(this._isGridOrList),
              ],
            ),
            color: Colors.grey[100],
          ),
          InkWell(
            onTap: () {
              showSearch(context: context, delegate: MySearchDelegate());
            },
            child: Container(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.search),
                  ),
                ],
              ),
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              height: 40,
            ),
          ),
          AnimatedContainer(
            child: Material(
              child: ListView(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        alterarPastasDeNotas();
                      });
                    },
                    child: ListTile(
                      title: Text("TESTE"),
                    ),
                  ),
                ],
              ),
            ),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: this._notesHeight,
            color: Colors.blue,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navegarParaEditNote(context: context, note: "Nova Nota");
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void navegarParaEditNote({@required BuildContext context, dynamic note}) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => EditNote(noteTitle: note)));
  }

  void alterarPastasDeNotas() {
    if (_isNotesOpen) {
      this._notesHeight = 0.0;
      this._isNotesOpen = false;
    } else {
      this._notesHeight = 200.0;
      this._isNotesOpen = true;
    }
  }
}
