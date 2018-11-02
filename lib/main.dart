import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/MoviesResponse.dart';
import 'movieDetail.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'styles/customStyles.dart';

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
String gifUrl = "https://media.giphy.com/media/o0vwzuFwCGAFO/giphy.gif";

Set<Movies> _filteredMovies = new Set();

Icon searchIcon = new Icon(Icons.search);

// Create a stateful widget
class MyGetHttpData extends StatefulWidget {
  @override
  MyGetHttpDataState createState() => new MyGetHttpDataState();
}

// Create the state for our stateful widget
class MyGetHttpDataState extends State<MyGetHttpData> {
  _fetchMovies(String page) async {
    Widget appBarTitle;
    final TextEditingController _filter = new TextEditingController();

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

    _showToast(String msg) {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1);
    }

    searchwidgetFunc() {
      setState(() {
        if (searchIcon.icon == Icons.search) {
          searchIcon = new Icon(Icons.close);
          appBarTitle = new TextField(
            controller: _filter,
            decoration: new InputDecoration(
                prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
          );
        } else {
          searchIcon = new Icon(Icons.search);
          appBarTitle = new Text('Search Example');
          _filteredMovies = moviesList as Set<Movies>;
          _filteredMovies.clear();
        }
      });
    }

    @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(
            "YTS Browse Movies",
            style: CustomStyles.appBarStyle,
          ),
          backgroundColor: Colors.black,
          actions: <Widget>[
            new IconButton(
              icon: searchIcon,
              onPressed: searchwidgetFunc,
            ),
          ],
        ),
        // Create a Listview and load the data when available
        body: new GridView.builder(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: .60),
            itemCount: mLimit,
            itemBuilder: (BuildContext context, int index) {
              if (index == mLimit - 10) {
                _fetchMovies((mPage++).toString());
              }
              return new Container(
                color: Colors.black54,
                child: new InkWell(
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new MovieDetail(
                              movies: moviesList[index] as Movies)));
                    },
                    child: new Card(
                        color: Colors.black,
                        elevation: 3.0,
                        child: new Column(
                          children: <Widget>[
                            new Center(
                              child: new CachedNetworkImage(
                                  placeholder:
                                      new Image.memory(kTransparentImage),
                                  imageUrl: moviesList[index].mediumCoverImage),
                            ),
                            new Text(moviesList[index].titleEnglish,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: CustomStyles.smallTxtStyle),
                            new Text("Rating " + moviesList[index].rating,
                                style: CustomStyles.smallTxtStyle),
                          ],
                        ))),
              );
            }),
      );
    }

    @override
    void initState() {
      super.initState();
      // Call the getJSONData() method when the app initializes
      this._fetchMovies(mPage.toString());
      print("app init");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  }
}
