import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_favorito/api.dart';
import 'package:youtube_favorito/model/video.dart';

class VideoBloc extends BlocBase {
  List<Video> videos = List<Video>();
  final Api api = Api();
  final _videosController = BehaviorSubject<List<Video>>(seedValue: []);
  final _searchController = StreamController<String>();

  Stream get outVideos => _videosController.stream;
  Sink get inSearch => _searchController.sink;

  VideoBloc() {
    _searchController.stream.listen(_search);
  }
  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }

  void _search(String query) async {
    if (query != null) {
      _videosController.sink.add([]);
      videos = await api.search(query);
    } else {
      videos += await api.nextPage();
    }
    _videosController.sink.add(videos);
  }
}
