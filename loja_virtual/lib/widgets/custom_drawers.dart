import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/drawer_tile.dart';
import 'package:loja_virtual/widgets/gradient_container_drawer.dart';

class CustomDrawer extends StatelessWidget {
  final _pageController;

  CustomDrawer(this._pageController);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Stack(
      children: <Widget>[
        GradientContainerDrawer(),
        ListView(
            padding: EdgeInsets.only(left: 32, top: 50),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Text(
                        "Flutter Store",
                        style: TextStyle(
                            fontSize: 34,
                            fontStyle: FontStyle.italic,
                            color: Colors.white),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Olá,",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            child: Text(
                              "Entre ou cadastre-se >>",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            onTap: () {},
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              DrawerTile(Icons.home, "Inicio", _pageController, 0),
              DrawerTile(Icons.list, "Produtos", _pageController, 1),
              DrawerTile(Icons.location_on, "Lojas", _pageController, 2),
              DrawerTile(
                  Icons.shopping_cart, "Meus Pedidos", _pageController, 3),
            ]),
      ],
    ));
  }
}
