import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_favorito/blocs/favorito_bloc.dart';
import 'package:youtube_favorito/blocs/video_bloc.dart';
import 'package:youtube_favorito/delegate/data_search_delegate.dart';
import 'package:youtube_favorito/pages/favoritos_screen.dart';
import 'package:youtube_favorito/widgets/video_tiles.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("images/yt_logo_rgb_dark.png"),
        ),
        elevation: 6,
        backgroundColor: Colors.black,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder(
              stream: BlocProvider.of<FavoritoBloc>(context).outFavoritos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text("${snapshot.data.length}");
                } else {
                  return Container();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FavoritoScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String resultado =
                  await showSearch(context: context, delegate: DataSearch());
              if (resultado != null) {
                BlocProvider.of<VideoBloc>(context).inSearch.add(resultado);
              }
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: bloc(context).outVideos,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length + 1,
              itemBuilder: (context, index) {
                if (index < snapshot.data.length) {
                  return VideoTile(snapshot.data[index]);
                } else if (index > 0) {
                  bloc(context).inSearch.add(null);
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container();
              },
            );
          }
        },
      ),
    );
  }

  VideoBloc bloc(BuildContext context) => BlocProvider.of<VideoBloc>(context);
}
