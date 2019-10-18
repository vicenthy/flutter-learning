import 'package:curso_lecheta/componentes/blue_button.dart';
import 'package:curso_lecheta/componentes/drawer_list.dart';
import 'package:curso_lecheta/pages/list_view.dart';
import 'package:curso_lecheta/pages/page2.dart';
import 'package:curso_lecheta/pages/page3.dart';
import 'package:curso_lecheta/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Hello flutter"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.star),
                child: Text("Tab 01"),
              ),
              Tab(
                icon: Icon(Icons.favorite),
                child: Text("Tab 01"),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _body(),
            Container(),
          ],
        ),
        drawer: DrawerList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _onclickFab,
        ),
      ),
    );
  }

  _onclickFab() {}
  _body() {
    return Container(
      child: _column(),
    );
  }

  _column() {
    return Builder(
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _text(),
            Container(
              height: 300,
              child: pageView(),
            ),
            rows(context)[0],
            rows(context)[1],
          ],
        );
      },
    );
  }

  rows(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          BlueButton(
              "ListView", () => _onclickNavigator(context, HelloListView())),
          BlueButton("Page 2", () => _onclickNavigator(context, Page2())),
          BlueButton("Page 3", () => _onclickNavigator(context, Page3())),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          BlueButton("Snak", () => _onclickSnak(context)),
          BlueButton("Dialog", () => _onclickDialog(context)),
          BlueButton("Toast", () => _onclickToast(context)),
        ],
      ),
    ];
  }

  PageView pageView() {
    return PageView(
      children: <Widget>[
        _img("atila.jpg"),
        _img("ingresso.png"),
        _img("logo.png"),
        _img("pizza.jpg"),
        _img("print.png"),
      ],
    );
  }

  _img(String img) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Image.asset(
        "assets/images/$img",
        width: 200,
        height: 200,
        fit: BoxFit.fill,
      ),
    );
  }

  _button(BuildContext context, String text, Function onPressed) {
    return BlueButton(text, onPressed);
  }

  _text() {
    return Text("Hello world!",
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 34,
        ));
  }

  _onclickNavigator(BuildContext context, Widget page) async {
    String s = await push(context, page);
    print(s);
  }

  _onclickDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              title: Text("Flutter é show"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    pop(context);
                  },
                  child: Text("Cancelar"),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                )
              ],
            ),
          );
        });
  }

  _onclickSnak(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Alo flutter"),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
      ),
    ));
  }

  _onclickToast(BuildContext context) {
    Fluttertoast.showToast(
        msg: "This is Center Short Toast",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
