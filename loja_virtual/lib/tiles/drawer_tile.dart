import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData _icon;
  final String _text;
  final _pageController;
  final int _page;
  DrawerTile(this._icon, this._text, this._pageController, this._page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          _pageController.jumpToPage(_page);
        },
        child: Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Icon(
                _icon,
                size: 32,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                _text,
              )
            ],
          ),
        ),
      ),
    );
  }
}
