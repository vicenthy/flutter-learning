import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GiphyPage extends StatelessWidget {


  final Map _giphyData;

  GiphyPage(this._giphyData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(_giphyData["title"] == null ? 'Sem Titulo' : _giphyData["title"], style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.black,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: (){
                Share.share(_giphyData["images"]["original"]["url"]);
              },
            )
          ],
        ),
      body: Center(
        child: Image.network(_giphyData["images"]["original"]["url"]),

      ),
      backgroundColor: Colors.black,
    );
  }
}
