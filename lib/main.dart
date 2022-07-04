import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? data;
  var imageUrl;
  void initState(){
    super.initState();
    getData();
  }


  void getData() async {
    http.Response response = await http.get(Uri.parse("https://meme-api.herokuapp.com/gimme"));
    if(response.statusCode==200){
      data = response.body;
      setState(() {
        imageUrl = jsonDecode(data!)['url']; //get all the data from json string superheros// just printed length of data
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("MemeHouse"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            FloatingActionButton.extended(
              label: Row(
                children: [
                  Icon(Icons.share_outlined),
                  Text(' Share'),
                ],
              ),
              backgroundColor: Colors.blue,
              onPressed: () {
                Share.share('Hello, Checkout this meme which is shared from app created by Mayank bhadeshiya -> $imageUrl');
              },
            ),
            Spacer(),
            FloatingActionButton.extended(
              label: Row(
                children: [
                  Icon(Icons.skip_next_outlined),
                  Text(' Next'),
                ],
              ),
              backgroundColor: Colors.blue,
              onPressed: () {
                getData();
                Fluttertoast.showToast(
                    msg: "loading next meme",  // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.CENTER,    // location
                    timeInSecForIosWeb: 4 // duration
                );
              },
            ),
          ],
        ),
      ),

      body: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [imageUrl == null ? Image.asset('assets/image/loading.png') :
                Image.network(
                    jsonDecode(data!)['url'],
                    fit: BoxFit.fill,
                    height: 550,
                    width: double.infinity,
                    alignment: Alignment.center),
              ],
            ),
          )
      );
  }
}
