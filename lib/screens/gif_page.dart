import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {

  final Map _gifdata;

  GifPage(this._gifdata);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Text(_gifdata["title"]),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              Share.share(_gifdata["images"]["fixed_height"]["url"]);
            }
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.blue,
                Colors.purple,
                Colors.red,
                Colors.yellow,
                Colors.green
              ]
            )
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifdata["images"]["fixed_height"]["url"]),
      ),
    );
  }
}