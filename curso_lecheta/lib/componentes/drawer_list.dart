import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text("usuario@email.com"),
              accountName: Text("Atila Augusto"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/images/atila.jpg"),
              ),
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("Teste"),
              onTap: () {
                Navigator.pop(context);
              },
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("Teste"),
              onTap: () {
                Navigator.pop(context);
              },
              trailing: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}
