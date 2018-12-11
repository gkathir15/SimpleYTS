import 'package:codelab_01/model/MoviesResponse.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:flutter/material.dart';

class Youtube extends StatelessWidget
{
  final String id;

  const Youtube( {Key key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(child: FlutterYoutube.playYoutubeVideoById(
  apiKey: "AIzaSyDZ7znhHwHRGqHSyR9uIJTJ8h1yXWFif0M",
  videoId:id,
  autoPlay: true, //default falase
  fullScreen: true //default false
),);
  }

}