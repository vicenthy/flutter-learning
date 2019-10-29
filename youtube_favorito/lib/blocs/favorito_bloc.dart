import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_favorito/model/video.dart';

class FavoritoBloc implements BlocBase {
  Map<String, Video> _favoritos = {};
  final _favoritoController =
      BehaviorSubject<Map<String, Video>>(seedValue: {});
  Stream<Map<String, Video>> get outFavoritos => _favoritoController.stream;

  FavoritoBloc() {
    getFromLocal();
  }

  void getFromLocal() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getKeys().contains("favoritos")) {
        _favoritos = json
            .decode(prefs.getString("favoritos"))
            .map((k, v) => MapEntry(k, Video.fromLocalJson(v)))
            .cast<String, Video>();
        _favoritoController.add(_favoritos);
      }
    });
  }

  void _salvarFavorito() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("favoritos", json.encode(_favoritos));
    });
  }

  void toggleFavorito(Video video) {
    if (_favoritos.containsKey(video.id)) {
      _favoritos.remove(video.id);
    } else {
      _favoritos[video.id] = video;
    }
    _favoritoController.sink.add(_favoritos);
    _salvarFavorito();
  }

  @override
  void dispose() {
    _favoritoController.close();
  }
}
