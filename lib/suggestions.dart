import 'package:cached_network_image/cached_network_image.dart';
import 'package:codelab_01/model/MoviesResponse.dart';
import 'package:codelab_01/movieDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'styles/customStyles.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'util/commonHelper.dart';

int movieId = 10;

class suggestions extends StatefulWidget {



  static getMovieId()
   {return movieId;}
  getSuggestions _getsuggestions = new getSuggestions();

  @override
  getSuggestions createState() => _getsuggestions;
  suggestions( {Key key,  movieId }) : super(key: key);



}

class getSuggestions extends State<suggestions>
{




  String _url = "https://yts.am/api/v2/movie_suggestions.json?movie_id=";
  MoviesResponse data;
  List moviesList = new List();

  _fetchMovies(int id) async {
    final response = await http.get(_url + id.toString());
    Map responseMap = json.decode(response.body);
    commonHelper.prettyPrint(response.body);

    data = new MoviesResponse.fromJson(responseMap);
    setState(() {
      moviesList.addAll(data.data.movies);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "Suggestions",
          style: CustomStyles.appBarStyle,
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: new GridView.builder(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: .60),
          itemCount: moviesList.length,
          addAutomaticKeepAlives: true,
          itemBuilder: (BuildContext context, int index) {
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
                            child: new Image.network(moviesList[index].mediumCoverImage),
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
   _fetchMovies(movieId);
 }


}
