import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/MoviesResponse.dart';
import 'movieDetail.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyGetHttpData(),
  ));
}

final String url = "https://yts.am/api/v2/list_movies.json?limit=50&page=";
MoviesResponse data;
List moviesList = new List();
int mPage = 1;
int mLimit = 0;

// Create a stateful widget
class MyGetHttpData extends StatefulWidget {
  @override
  MyGetHttpDataState createState() => new MyGetHttpDataState();
}

// Create the state for our stateful widget
class MyGetHttpDataState extends State<MyGetHttpData> {
  fetchMovies(String page) async {
    final response = await http.get(url + page);
    Map responseMap = json.decode(response.body);
    print(response.body);
    setState(() {
      data = new MoviesResponse.fromJson(responseMap);
      moviesList.addAll(data.data.movies);
      mLimit = mLimit + data.data.limit;
      if (data.data.pageNumber != 1) {
        mPage = mPage + data.data.pageNumber;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("YTS Browse Movies"),
      ),
      // Create a Listview and load the data when available
      body: new ListView.builder(
          itemCount: mLimit,
          itemBuilder: (BuildContext context, int index) {
            if (index == mLimit - 10) {
              fetchMovies((mPage++).toString());
            }
            return new Container(
              child: new Center(
                  child: new Column(
                // Stretch the cards in horizontal axis
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => new MovieDetail(
                                movies: moviesList[index] as Movies)));
                      },
                      child: new Card(
                        child: new Column(
                          children: <Widget>[
                            new Text(moviesList[index].title,
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.black)),
                            new Text("Rating " + moviesList[index].rating,
                                style: new TextStyle(
                                    fontSize: 15.0, color: Colors.black)),
                            new Image.network(
                              moviesList[index].mediumCoverImage,
                              width: 200.0,
                              height: 400.0,
                            ),
                            new Text(
                              moviesList[index].summary,
                              style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      )),
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
    this.fetchMovies(mPage.toString());
    print("app init");
  }
}
