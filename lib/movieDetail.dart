// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'model/MoviesResponse.dart';
import 'package:url_launcher/url_launcher.dart';
import 'styles/customStyles.dart';

final String id = "";
String magnetPrefix = 'magnet:?xt=urn:btih:';

class MovieDetail extends StatelessWidget {
  final Movies movies;
  MovieDetail({Key key, @required this.movies}) : super(key: key);

  Future<Null> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
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
        ),
        body: new Container(
            color: Colors.black54,
            child: new Column(children: <Widget>[
              new Row(
                children: <Widget>[
                  new Image.network(movies.mediumCoverImage),
                  new Padding(
                      padding: EdgeInsets.all(1.0),
                      child: new Column(
                        children: <Widget>[
                          new Text(
                            movies.title,
                            style: CustomStyles.movieDetail,
                          ),
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
                ],
              ),
              new Text(
                movies.descriptionFull,
                style: CustomStyles.movieDetail,
              ),
              new Expanded(
                child: new ListView.builder(
                    itemCount: movies.torrents.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        child: new Chip(
                          label: new InkWell(
                            child: new Text(movies.torrents[index].quality),
                            onTap: () {
                              _launchInBrowser(
                                  magnetPrefix + movies.torrents[index].hash);
                            },
                          ),
                        ),
                      );
                    }),
              )
            ])));
  }
}
