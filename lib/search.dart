import 'package:flutter/material.dart';
import 'dart:async';
import 'model/MoviesResponse.dart';
import 'styles/customStyles.dart';
import 'movieDetail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchList extends StatefulWidget {
  SearchList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchState();
}

class _SearchState extends State<SearchList> {
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  bool _isSearching = false;
  String _error;
  List<Movies> moviesList = List();
  String _url = "https://yts.am/api/v2/list_movies.json?query_term=";
  MoviesResponse data;

  Timer debounceTimer;

  _SearchState() {
    _searchQuery.addListener(() {
      if (debounceTimer != null) {
        debounceTimer.cancel();
      }
      debounceTimer = Timer(Duration(milliseconds: 500), () {
        if (this.mounted) {
          performSearch(_searchQuery.text);
        }
      });
    });
  }

  void performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _error = null;
        moviesList = List();
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
      moviesList = List();
    });

    final repos = await searchMovies(query);
    if (this._searchQuery.text == query && this.mounted) {
      setState(() {
        _isSearching = false;
        if (repos != null) {
          moviesList = repos;
        } else {
          _error = 'Error searching repos';
        }
      });
    }
  }

  Future<List<Movies>> searchMovies(String query) async {
    final response = await http.get(_url + query);
    Map responseMap = json.decode(response.body);
    print(response.body);
      data = new MoviesResponse.fromJson(responseMap);
      return data.data.movies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        appBar: AppBar(
          centerTitle: true,
          title: TextField(
            autofocus: true,
            controller: _searchQuery,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Padding(
                    padding: EdgeInsetsDirectional.only(end: 16.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    )),
                hintText: "Search repositories...",
                hintStyle: TextStyle(color: Colors.white)),
          ),
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    if (_isSearching) {
      return CenterTitle('Searching YTS...');
    } else if (_error != null) {
      return CenterTitle(_error);
    } else if (_searchQuery.text.isEmpty) {
      return CenterTitle('Begin Search by typing on search bar');
    } else {
      return new GridView.builder(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: .60),
          itemCount: moviesList.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              color: Colors.black54,
              child: new InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new MovieDetail(
                            movies: moviesList[index])));
                  },
                  child: new Card(
                      color: Colors.black,
                      elevation: 3.0,
                      child: new Column(
                        children: <Widget>[
                          new Center(
                            child: new Image.network(moviesList[index].mediumCoverImage,),
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
          });
    }
  }
}

class CenterTitle extends StatelessWidget {
  final String title;

  CenterTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        alignment: Alignment.center,
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline,
          textAlign: TextAlign.center,
        ));
  }
}
