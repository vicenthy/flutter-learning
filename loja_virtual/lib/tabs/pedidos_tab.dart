import 'package:flutter/material.dart';
import 'package:loja_virtual/widgets/gradient_container.dart';

class PedidoTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GradientContainer(),
        CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Pedidos"),
              centerTitle: true,
            ),
          ),
        ])
      ],
    );
  }
}
