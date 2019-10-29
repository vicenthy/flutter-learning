import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:youtube_favorito/blocs/favorito_bloc.dart';
import 'package:youtube_favorito/model/video.dart';

import '../api.dart';

class VideoTile extends StatelessWidget {
  final Video _video;
  VideoTile(this._video);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FlutterYoutube.playYoutubeVideoById(
            appBarColor: Colors.black,
            autoPlay: true,
            videoId: _video.id,
            backgroundColor: Colors.black,
            apiKey: API_KEY);
      },
      child: Container(
        margin: EdgeInsets.only(top: 6, right: 2, left: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                _video.thumb,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          _video.title,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          _video.channel,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                StreamBuilder(
                    stream: blocF(context).outFavoritos,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return IconButton(
                          icon: Icon(
                            snapshot.data.containsKey(_video.id)
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.yellow,
                            size: 30,
                          ),
                          onPressed: () {
                            blocF(context).toggleFavorito(_video);
                          },
                        );
                      } else {
                        return Container();
                      }
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

  FavoritoBloc blocF(BuildContext context) =>
      BlocProvider.of<FavoritoBloc>(context);

  iniciarIcone(BuildContext context) {
    blocF(context).getFromLocal();
  }
}
