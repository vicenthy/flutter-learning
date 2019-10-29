import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_favorito/api.dart';
import 'package:youtube_favorito/blocs/favorito_bloc.dart';
import 'package:youtube_favorito/blocs/video_bloc.dart';
import 'package:youtube_favorito/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        bloc: VideoBloc(),
        child: BlocProvider(
          bloc: FavoritoBloc(),
          child: MaterialApp(
            title: 'Video',
            home: Home(),
          ),
        ));
  }
}
