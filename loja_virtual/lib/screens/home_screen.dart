import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/home_tab.dart';
import 'package:loja_virtual/tabs/lojas_tab.dart';
import 'package:loja_virtual/tabs/pedidos_tab.dart';
import 'package:loja_virtual/tabs/produto_tab.dart';
import 'package:loja_virtual/widgets/custom_drawers.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          body: ProdutoTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          body: LojasTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          body: PedidoTab(),
          drawer: CustomDrawer(_pageController),
        ),
      ],
    );
  }
}
