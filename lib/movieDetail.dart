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

final String id = "";
String magnetPrefix = 'magnet:?xt=urn:btih:';

class MovieDetail extends StatelessWidget {
  final Movies movies;
  MovieDetail({Key key, @required this.movies}) : super(key: key);

  Future<Null> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: !Platform.isAndroid, forceWebView: false);
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
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.more,color: Colors.white,),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => suggestions(movieId:movies.id),
                      ));
                }
            ),
          ],
        ),
        body: new SingleChildScrollView(

    child: new ConstrainedBox(
    constraints: new BoxConstraints(minHeight: 300.00,maxHeight: 1000.00),
            //color: Colors.black54,
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
                child: new GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 1.0),
                    itemCount: movies.torrents.length,
                    shrinkWrap: true,
                    //scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        child: new Padding(padding: EdgeInsets.all(3.0),
                        child: new Chip(padding:EdgeInsets.all(1.0),
                          avatar: new Image.asset("assets/png/magnet.png"),
                          label: new InkWell(
                            child: new Text(movies.torrents[index].quality),
                            onTap: () {
                              _launchInBrowser(
                                  magnetPrefix + movies.torrents[index].hash);
                            },
                          ),
                        ),
                        ),
                      );
                    }),
              )
            ])))
  );
}}
