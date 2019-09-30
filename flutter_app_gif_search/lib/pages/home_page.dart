import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:share/share.dart';
import 'giphy_page.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _search = "";
  var _limit = 7;
  var _offset = 0;

  Future<Map> _getGiphy() async {
    http.Response response;
    if (_search != "") {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=Gb356Ht49gn7zA3aELTLxCA2o4DHmM9b&q=${_search}&limit=${_limit}&offset=${_offset}&rating=G&lang=pt");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=Gb356Ht49gn7zA3aELTLxCA2o4DHmM9b&limit=${_limit}&offset=${_offset}&rating=G");
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGiphy().then((result) => {print(result)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              cursorColor: Colors.white,
              decoration: InputDecoration(
                labelText: "Pesquise aqui",
                labelStyle: TextStyle(color: Colors.white),
                border: _getDefaultBorder(),
                enabled: true,
                enabledBorder: _getDefaultBorder(),
                focusedBorder: _getDefaultBorder(),
              ),
              style: TextStyle(color: Colors.white),
              onSubmitted: (String text){
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGiphy(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.waiting:
                    return Container(
                      alignment: Alignment.center,
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container(
                        child: Text(
                          "ERRO!",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return _createGiphyTable(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  OutlineInputBorder _getDefaultBorder() {
    return OutlineInputBorder(borderSide: BorderSide(color: Colors.white));
  }


  int _getCount(List data){
      return data.length + 1;
  }


  Widget _createGiphyTable(
      BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index){

        if(index == snapshot.data["data"].length ){
          return _getMoreButton(context, snapshot);
        }if(_search == "" || index < snapshot.data["data"].length){
            return _getImage(context, snapshot, index);
        }else{
          return _getMoreButton(context, snapshot);
        }

      },
    );

  }


  Widget _getMoreButton(BuildContext context, AsyncSnapshot snapshot){
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.add, size: 78, color: Colors.white,),
          Text("Carregar mais...", style: TextStyle(color: Colors.white, fontSize: 22),)
        ],
      ),
      onTap: (){
          setState(() {
            _offset +=_limit;
          });
      },
    );

  }


  Widget _getImage(BuildContext context, AsyncSnapshot snapshot, index) {
    return GestureDetector(
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
        height: 300,
        fit: BoxFit.cover,

      ),
      onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => GiphyPage(snapshot.data["data"][index])
            ));
      },
      onLongPress: (){
        Share.share(snapshot.data["data"][index]["images"]["original"]["url"]);
      },
    );
  }


}






