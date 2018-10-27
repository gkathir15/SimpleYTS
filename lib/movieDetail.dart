import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'model/MoviesResponse.dart';
import 'package:share/share.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:advanced_share/advanced_share.dart' show AdvancedShare;
import 'package:url_launcher/url_launcher.dart';

final String id = "";
String magnetPrefix = 'magnet:?xt=urn:btih:';

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
        title: Text(movies.title),
      ),
      body: Center(
        child: new Column(
          children: <Widget>[
            new Image.network(movies.mediumCoverImage),
            Padding(
              padding: EdgeInsets.all(6.0),
              child: new Text(
                movies.descriptionFull,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: new ListView.builder(
                    itemCount: movies.torrents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          child: new Center(
                              child: new Column(
                                  // Stretch the cards in horizontal axis
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Text(movies.torrents[index].quality,
                                    style: new TextStyle(
                                        fontSize: 15.0, color: Colors.black)),
                                new Text(movies.torrents[index].size,
                                    style: new TextStyle(
                                        fontSize: 15.0, color: Colors.black)),
                                new Text(
                                    movies.torrents[index].seeds.toString(),
                                    style: new TextStyle(
                                        fontSize: 15.0, color: Colors.black)),
                              ],
                            )
                          ])));
                    }),
              ),
            )
//            new InkWell(
//              onTap: () {
//                _launchInBrowser(movies.torrents[0].url);
//                // Share.share("data:text/link;" + movies.torrents[0].url);
//
//                // AdvancedShare.generic(movies.title,movies.torrents[0].url,Link to Torrent,)
//              },
//              child: Padding(
//                padding: EdgeInsets.all(8.0),
//                child: new Text(
//                  "Click to get Torrent:  " +
//                      movies.titleEnglish +
//                      "  Size: " +
//                      movies.torrents[0].size,
//                  style: new TextStyle(fontSize: 20.0, color: Colors.indigo),
//                ),
//              ),
//            )
          ],
        ),
      ),
    );
  }
}
