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
  List<People> data = List();
  var isLoading = false;

 @override
 void initState(){
   super.initState();
   //load json data
   this.getJsonData();
 }
Future<PeopleResponse> getJsonData() async {
   isLoading = true;
   var reponse = await http.get(
     //Encode the url 
     Uri.encodeFull(url),
      //Only accept json response
      headers: {"Accept":"application/json"}
   );
   print(reponse.body);
     if (reponse.statusCode == 200) {
        var convertDataToJson = json.decode(reponse.body);
        PeopleResponse subMenuRes = PeopleResponse.fromJson(convertDataToJson);
        data = subMenuRes.results;
      setState(() {
      isLoading = false ;
      });
    } else {
      throw Exception('Failed to parse');
    }
}      

   @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Starwars Guide"),
      ),
       body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
        : new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context,int index){
          return new Container(
            child: new Center(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Card(
                    child: new Container(
                      child: new Text(data[index].name),
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

class People {
final String name;
final String height;
People({this.name,this.height});
factory People.fromJson(Map json) {
  return People(
    name: json["name"],
    height: json["height"]
  );
}
}
class PeopleResponse {
final int count;
final List<People> results;
PeopleResponse({this.count, this.results});
factory PeopleResponse.fromJson(Map json) {
  return PeopleResponse(
    count: json['count'],
    results: (json['results'] as List).map((i) => new 
  People.fromJson(i)).toList(),
  );
  }
}


