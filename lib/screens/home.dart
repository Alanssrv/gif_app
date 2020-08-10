import 'package:flutter/material.dart';
import 'package:gif_app/screens/gif_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController controller = TextEditingController();
  String _search;
  int _offset = 0;

  int _getCount(List data){
    if(_search == null){
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Future<Map> _getGifs() async {
    http.Response response;

    if(_search == null || _search.isEmpty){
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=BgaRUyYO7OzY1ds47EyBIFBwCttJW35W&limit=20&rating=g");
    }else{
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=BgaRUyYO7OzY1ds47EyBIFBwCttJW35W&q=$_search&limit=19&offset=$_offset&rating=g&lang=pt");
    }

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: GestureDetector(
          child: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
          onTap: (){
            setState(() {
              _search = null;
              controller.clear();
              FocusScope.of(context).unfocus();
            });
          },
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15,),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Procure um Gif",
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
                ),
              ),
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                    break;
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _gifTable(context, snapshot);
                    }
                }
              }
            )
          )
        ],
      ),
    );
  }

  Widget _gifTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (_context, index){
        if (_search == null || index < snapshot.data["data"].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300,
              fit: BoxFit.cover,
            ),
            onTap: (){
              Navigator.push(context, 
                MaterialPageRoute(
                  builder: (context)=>GifPage(snapshot.data["data"][index])
                )
              );
            },
            onLongPress: (){
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70,
                  ),
                  Text(
                    "Carregar mais...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22
                    ),
                  )
                ],
              ),
              onTap: (){
                setState(() {
                  _offset += 19;
                });
              },
            ),
          );
        }
      }
    );
  }
}