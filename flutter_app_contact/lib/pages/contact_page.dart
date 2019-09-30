import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_contact/helpers/contact_helper.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editContact;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  bool _editing = false;

  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.contact != null) {
      _editContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editContact.nome;
      _telefoneController.text = _editContact.telefone;
      _emailController.text = _editContact.email;
    } else {
      _editContact = Contact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editContact.nome ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editContact.nome != null) {
              Navigator.pop(context, _editContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: _showOpcoes,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editContact.img != null
                              ? FileImage(File(_editContact.img))
                              : AssetImage("images/contact.png"))),
                ),
              ),
              TextField(
                focusNode: _nameFocus,
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  setState(() {
                    _editing = true;
                    _editContact.nome = text;
                  });
                },
              ),
              TextField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                keyboardType: TextInputType.phone,
                onChanged: (text) {
                  _editing = true;
                  _editContact.telefone = text;
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                onChanged: (text) {
                  _editing = true;
                  _editContact.email = text;
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _showOpcoes() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ImagePicker.pickImage(source: ImageSource.camera)
                            .then((file) {
                          if (file != null) {
                            setState(() {
                              _editContact.img = file.path;
                            });
                          } else {
                            return;
                          }
                        });
                      },
                      child: Text("Camera"),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ImagePicker.pickImage(source: ImageSource.gallery)
                            .then((file) {
                          if (file != null) {
                            setState(() {
                              _editContact.img = file.path;
                            });
                          } else {
                            return;
                          }
                        });
                      },
                      child: Text("Galeria"),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  Future<bool> _requestPop() async {
    if (_editing) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações"),
              content: Text("Suas Alterações serão perdidas"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar"),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Sim"),
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
