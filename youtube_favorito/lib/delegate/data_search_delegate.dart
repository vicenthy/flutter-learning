import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  void showResults(BuildContext context) {
    close(context, query);
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(query),
          leading: Icon(Icons.play_arrow),
          onTap: () {
            close(context, query);
          },
        );
      },
      itemCount: 1,
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      return FutureBuilder<List<String>>(
        future: obtersugestoes(query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data[index]),
                  leading: Icon(Icons.play_arrow),
                  onTap: () {
                    close(context, snapshot.data[index]);
                  },
                );
              },
              itemCount: snapshot.data.length,
            );
          }
        },
      );
    }

    return Container();
  }

  Future<List<String>> obtersugestoes(String termoPesquisado) async {
    http.Response response = await http.get(
        "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$termoPesquisado&format=5&alt=json");

    if (response.statusCode == 200) {
      return json
          .decode(response.body)[1]
          .map<String>((value) => value[0] as String)
          .toList();
    } else {
      throw Exception("error o obter sugestões");
    }
  }

  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => "Pesquisar";
}
