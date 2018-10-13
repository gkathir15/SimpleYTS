import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/MoviesResponse.dart';
void main() {
  runApp(new MaterialApp(
    home: new MyGetHttpData(),
  ));

}

final String url = "https://yts.am/api/v2/list_movies.json";
MoviesResponse data;
List moviesList= new List();

// Create a stateful widget
class MyGetHttpData extends StatefulWidget {
  @override
  MyGetHttpDataState createState() => new MyGetHttpDataState();
}

// Create the state for our stateful widget
class MyGetHttpDataState extends State<MyGetHttpData> {





    fetchMovies() async {
    final response = await http.get(url);
    Map responseMap = json.decode(response.body);
    print(response.body);
    setState(() {
      data =  new MoviesResponse.fromJson(responseMap);
      moviesList.addAll(data.data.movies);
    });



  }

//  MoviesResponse parsePhotos(String responseBody) {
//     print("call network");
////    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
////    return parsed.map<MoviesResponse>((json) => MoviesResponse.fromJson(json))
////        .toList();
//  Map responseMap = json.decode(responseBody);
//  var convertData =new MoviesResponse.fromJson(responseMap);
//  return convertData;
//
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("YTS Browse Movies"),
      ),
      // Create a Listview and load the data when available
      body: new ListView.builder(
          itemCount: data.data.limit,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              child: new Center(
                  child: new Column(
                    // Stretch the cards in horizontal axis
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new Card(
                        child: new Container(
                          child: new Text(
                            // Read the name field value and set it in the Text widget
                            //data.status,
                            //"working",
                            moviesList[index].title,
                            // set some style to text
                            style: new TextStyle(
                                fontSize: 20.0, color: Colors.lightBlueAccent),
                          ),
                          // added padding
                          padding: const EdgeInsets.all(15.0),
                        ),
                      )
                    ],
                  )),
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    // Call the getJSONData() method when the app initializes
      this.fetchMovies();
    print("app init");
  }
}