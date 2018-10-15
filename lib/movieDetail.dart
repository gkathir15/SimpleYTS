// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'model/MoviesResponse.dart';
import 'package:share/share.dart';
//import 'package:flutter_share/flutter_share.dart';


final String id = "";

class MovieDetail extends StatelessWidget {
  final Movies movies;
  MovieDetail({Key key, @required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Second Screen"),
      ),
      body: Center(
        child: new Column(
          children: <Widget>[
            new Image.network(movies.backgroundImage),
            new Text(movies.summary),
            new InkWell(
              onTap: () {
                Share.share(movies.torrents[0].url);
              },
              child: new Text("Torrent" + movies.titleEnglish),
            )
          ],
        ),
      ),
    );
  }
}
