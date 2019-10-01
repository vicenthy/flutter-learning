import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(HomePage());
}

final googlesign = GoogleSignIn();
final auth = FirebaseAuth.instance;

Future<Null> _verificarLogin() async {
  GoogleSignInAccount user = googlesign.currentUser;
  if (user == null) {
    user = await googlesign.signInSilently();
    if (user == null) {
      user = await googlesign.signIn();
      if (await auth.currentUser() == null) {
        GoogleSignInAuthentication credentials =
            await googlesign.currentUser.authentication;
        await auth.signInWithCredential(GoogleAuthProvider.getCredential(
            idToken: credentials.idToken,
            accessToken: credentials.accessToken));
      }
    }
  }
}

_enviarMensagem(String msg) async {
  await _verificarLogin();
  _enviar(msg: msg);
}

_enviar({String msg, String urlImg}) {
  Firestore.instance.collection("mensagens").add({
    "msg": msg,
    "imgUrl": urlImg,
    "user": googlesign.currentUser.displayName,
    "userFoto": googlesign.currentUser.photoUrl,
    "dataEnvio": new DateTime.now().toIso8601String()
  });
}

final _msgController = TextEditingController();

final ThemeData iosCustomTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData androidCustomTheme =
    ThemeData(primarySwatch: Colors.purple, accentColor: Colors.orange[400]);

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Flutter",
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).platform == TargetPlatform.iOS
          ? iosCustomTheme
          : androidCustomTheme,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key}) : super(key: key);

  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat Flutter"),
          centerTitle: true,
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection("mensagens")
                    .orderBy('dataEnvio')
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return ChatMessage(
                              snapshot.data.documents[index].data);
                        },
                      );
                  }
                },
              ),
            ),
            Divider(
              height: 1.0,
              color: Colors.grey[100],
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: TextCompose(),
            )
          ],
        ),
      ),
    );
  }
}

class TextCompose extends StatefulWidget {
  TextCompose({Key key}) : super(key: key);

  _TextComposeState createState() => _TextComposeState();
}

class _TextComposeState extends State<TextCompose> {
  bool escrevendo = false;

  void _reset() {
    setState(() {
      _msgController.clear();
      escrevendo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200])))
            : null,
        child: Row(
          children: <Widget>[
            Container(
              child: IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () async {
                  await _verificarLogin();
                  File file =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  if (file != null) {
                    StorageUploadTask task = FirebaseStorage.instance
                        .ref()
                        .child(googlesign.currentUser.id +
                            DateTime.now().millisecondsSinceEpoch.toString())
                        .putFile(file);
                    String url =
                        await (await task.onComplete).ref.getDownloadURL();
                    _enviar(urlImg: url);
                  }
                },
              ),
            ),
            Expanded(
              child: TextField(
                controller: _msgController,
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar Mensagem"),
                onChanged: (text) {
                  setState(() {
                    escrevendo = text.length > 0;
                  });
                },
                onSubmitted: (text) {
                  _enviarMensagem(_msgController.text);
                  _reset();
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoButton(
                      child: Text("Enviar"),
                      onPressed: escrevendo
                          ? () {
                              _enviarMensagem(_msgController.text);
                              _reset();
                            }
                          : null,
                    )
                  : IconButton(
                      icon: Icon(Icons.send),
                      onPressed: escrevendo
                          ? () {
                              _enviarMensagem(_msgController.text);
                              _reset();
                            }
                          : null,
                    ),
            )
          ],
        ),
      ),
    );
    ;
  }
}

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;

  ChatMessage(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(data["userFoto"]),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(data["user"],
                      style: Theme.of(context).textTheme.subhead),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: data["imgUrl"] != null
                        ? Image.network(
                            data["imgUrl"],
                            width: 250,
                          )
                        : Text(data["msg"]),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
