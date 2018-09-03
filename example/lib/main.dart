import 'dart:async';

import 'package:example/basic_menu.dart';
import 'package:example/fix_menu.dart';
import 'package:example/header_menu.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_menu/dropdown_header.dart';
import 'dart:math' as math;
import 'package:dropdown_menu/dropdown_templates.dart';
import 'package:dropdown_menu/dropdown_sliver.dart';
import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:dropdown_menu/dropdown_list_menu.dart';
import 'dart:io';
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body:new IndexedStack(
        children: <Widget>[
          new BasicMenu(),
          new FixMenu(),
          new HeaderMenu(),

        ],
        index: _currentIndex,
      ),
      bottomNavigationBar: new BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          items: [
          {"name": "Basic", "icon": Icons.watch},
            {"name": "Fix", "icon": Icons.hearing},
            {"name": "ScrollView", "icon": Icons.list},

          ]
              .map((dynamic data) => new BottomNavigationBarItem(
                  title: new Text(data["name"]), icon: new Icon(data["icon"])))
              .toList()),
    );
  }
}
