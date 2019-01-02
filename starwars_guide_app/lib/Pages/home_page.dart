import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class HomePage extends StatefulWidget{
  @override
  HomePageState createState()=> new HomePageState();
}

class HomePageState extends State<HomePage>{
  final String url = "https://swapi.co/api/people";
  List data;

 @override
 void initState(){
   super.initState();
   //load json data
   this.getJsonData();
 }
 Future<String> getJsonData() async {
   var reponse = await http.get(
     //Encode the url 
     Uri.encodeFull(url),
      //Only accept json response
      headers: {"Accept":"application/json"}
   );
   print(reponse.body);
   setState(() {
        var convertDataToJson = json.decode(reponse.body);
        data = convertDataToJson['results'];
      });
      return "Success";
 }//return type

   @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Starwars Guide"),
      ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context,int index){
          return new Container(
            child: new Center(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Card(
                    child: new Container(
                      child: new Text(data[index]['name']),
                      padding: const EdgeInsets.all(20.0),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}