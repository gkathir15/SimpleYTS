// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'model/MoviesResponse.dart';
import 'package:share/share.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:advanced_share/advanced_share.dart' show AdvancedShare;
import 'package:url_launcher/url_launcher.dart';

final String id = "";

class MovieDetail extends StatelessWidget {
  final Movies movies;
  MovieDetail({Key key, @required this.movies}) : super(key: key);

  Future<Null> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

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
            new Text(
              movies.summary,
            ),
            new InkWell(
              onTap: () {
                _launchInBrowser(movies.torrents[0].url);
                // Share.share("data:text/link;" + movies.torrents[0].url);

                // AdvancedShare.generic(movies.title,movies.torrents[0].url,Link to Torrent,)
              },
              child: new Text(
                "Torrent" + movies.titleEnglish,
                style: new TextStyle(
                  fontSize: 15.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
