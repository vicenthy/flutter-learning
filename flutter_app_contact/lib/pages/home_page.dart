import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_contact/helpers/contact_helper.dart';
import 'package:flutter_app_contact/pages/contact_page.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions { ASC, DESC }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper contactHelper = ContactHelper();
  List<Contact> contactList = List();

  @override
  void initState() {
    super.initState();
    _getAllcontact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          "Contatos",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem(
                child: Text("Ordem crescente"),
                value: OrderOptions.ASC,
              ),
              const PopupMenuItem(
                child: Text("Ordem decrescente"),
                value: OrderOptions.DESC,
              ),
            ],
            onSelected: _orderItens,
          )
        ],
      ),
      body: _createListView(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _createListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: contactList.length,
      itemBuilder: (context, index) {
        return _cardItem(context, index);
      },
    );
  }

  Widget _cardItem(BuildContext context, index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _showOpcoes(context, index);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: contactList[index].img != null
                            ? FileImage(File(contactList[index].img))
                            : AssetImage("images/contact.png"),
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contactList[index].nome ?? "",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contactList[index].email ?? "",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      contactList[index].telefone ?? "",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showOpcoes(BuildContext context, int index) {
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showContactPage(contact: contactList[index]);
                          },
                          child: Text(
                            "Editar",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            contactHelper.deleteContact(contactList[index].id);
                            setState(() {
                              Navigator.pop(context);
                              contactList.removeAt(index);
                            });
                          },
                          child: Text(
                            "Excluir",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                            launch("tel:${contactList[index].telefone}");
                          },
                          child: Text(
                            "Ligar",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
        });
  }

  void _showContactPage({Contact contact}) async {
    final reContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));
    print(reContact);
    print(contact);
    if (reContact != null) {
      if (contact != null) {
        await contactHelper.updateContact(reContact);
      } else {
        await contactHelper.saveContact(reContact);
      }
    }
    await _getAllcontact();
  }

  _orderItens(OrderOptions result) {
    setState(() {
      switch (result) {
        case OrderOptions.ASC:
          return contactList.sort((a1, a2) =>
              a1.nome.toLowerCase().compareTo(a2.nome.toLowerCase()));
          break;
        case OrderOptions.DESC:
          return contactList.sort((a1, a2) =>
              a2.nome.toLowerCase().compareTo(a1.nome.toLowerCase()));
          break;
      }
    });
  }

  _getAllcontact() {
    contactHelper.getAllcontact().then((value) {
      setState(() {
        contactList = value;
      });
    });
  }
}
