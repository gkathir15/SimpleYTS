// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'model/MoviesResponse.dart';
import 'package:url_launcher/url_launcher.dart';
import 'styles/customStyles.dart';
import 'dart:io';
import 'suggestions.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:codelab_01/youtubePage.dart';

final String id = "";
String magnetPrefix = 'magnet:?xt=urn:btih:';

class MovieDetail extends StatelessWidget {
  final Movies movies;
  MovieDetail({Key key, @required this.movies}) : super(key: key);

  Future<Null> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url,
          forceSafariVC: !Platform.isAndroid, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  String youtubeId(Movies movies) {
    String id = "B2EI65ZEqYQ";
    if (movies.ytTrailerCode != null && movies.ytTrailerCode != "")
      id = movies.ytTrailerCode;

    return id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(
            movies.title,
            style: CustomStyles.appBarStyle,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.videocam),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Youtube(
                              id: youtubeId(movies),
                            )));
              },
            ),
            IconButton(
                icon: Icon(
                  Icons.more,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => suggestions(movieId: movies.id),
                      ));
                }),
          ],
        ),
        body: new Container(
            color: Colors.black,
            child: new ListView(
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                children: <Widget>[
                  new Column(children: <Widget>[
                    new Image.network(movies.mediumCoverImage),
                    new Padding(
                        padding: EdgeInsets.all(1.0),
                        child: new Column(
                          children: <Widget>[
                            new Text(
                              movies.language,
                              style: CustomStyles.movieDetail,
                            ),
                            new Text(
                              "Rating " + movies.rating,
                              style: CustomStyles.movieDetail,
                            ),
                            new Text(movies.year.toString(),
                                style: CustomStyles.movieDetail),
                          ],
                        )),
                    new Text(
                      movies.descriptionFull,
                      style: CustomStyles.movieDetail,
                    ),
                    new GridView.builder(
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, childAspectRatio: 1.0),
                        itemCount: movies.torrents.length,
                        shrinkWrap: true,
                        //scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return new Container(
                            child: new Padding(
                              padding: EdgeInsets.all(3.0),
                              child: new Chip(
                                padding: EdgeInsets.all(1.0),
                                avatar:
                                    new Image.asset("assets/png/magnet.png"),
                                label: new InkWell(
                                  child:
                                      new Text(movies.torrents[index].quality),
                                  onTap: () {
                                    _launchInBrowser(magnetPrefix +
                                        movies.torrents[index].hash);
                                  },
                                ),
                              ),
                            ),
                          );
                        }),
                  ])
                ])));
  }
}
