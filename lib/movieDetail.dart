// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'model/MoviesResponse.dart';

final Movies movies=new Movies();
final String id="";

class MovieDetail extends StatefulWidget {


  MovieDetail(id);

  @override
  Widget build(BuildContext context) {
    // Here is just a placeholder for a list of mock units
    return Scaffold(
      appBar: AppBar(
        title: Text(id),
        centerTitle: true,
      ),
      body: Center(
        child: new Text(movies.summary),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

  }
}
