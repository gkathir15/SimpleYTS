import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/MoviesResponse.dart';
import 'styles/customStyles.dart';
import 'search.dart';
import 'util/commonHelper.dart';
import 'widgets/MovieTile.dart';

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
      final response = await http.get(url + page);
      Map responseMap = json.decode(response.body);
      commonHelper.prettyPrint(response.body);
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
        bottomNavigationBar: new BottomNavigationBar(items: <BottomNavigationBarItem>[new BottomNavigationBarItem(icon: new Icon(Icons.movie),title: new Text('Movies')),new BottomNavigationBarItem(icon: new Icon(Icons.star),title: new Text('Favourites'))],),
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(
            "YTS Browse Movies",
            style: CustomStyles.appBarStyle,
          ),
          backgroundColor: Colors.black,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search,color: Colors.white,),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchList(),
                      ));
                }
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
              return new MovieTile(moviesData: moviesList[index],);
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





