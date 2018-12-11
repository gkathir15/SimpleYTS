import 'package:cached_network_image/cached_network_image.dart';
import 'package:codelab_01/model/MoviesResponse.dart';
import 'package:codelab_01/movieDetail.dart';
import 'package:codelab_01/styles/customStyles.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieTile extends StatelessWidget {
  final Movies moviesData;

  const MovieTile({Key key, this.moviesData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      color: Colors.black54,
      child: new InkWell(
          enableFeedback: false,
          highlightColor: Colors.black12,
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new MovieDetail(movies: moviesData as Movies)));
          },
          child: new Card(
            color: Colors.black,
            elevation: 3.0,
            child: new CachedNetworkImage(
                placeholder: new Image.memory(kTransparentImage),
                imageUrl: moviesData.mediumCoverImage),
          )),
    );
  }
}

//
//new Column(
//children: <Widget>[
//new CachedNetworkImage(
//placeholder: new Image.memory(kTransparentImage),
//imageUrl: moviesData.mediumCoverImage),
//new Text(moviesData.titleEnglish,
//softWrap: true, style: CustomStyles.smallTxtStyle),
//new Text("Rating " + moviesData.rating,
//overflow: TextOverflow.ellipsis,
//style: CustomStyles.smallTxtStyle),
//],
//)
