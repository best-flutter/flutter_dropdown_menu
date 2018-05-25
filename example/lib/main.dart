import 'dart:async';

import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:async_loader/async_loader.dart';

import 'package:dropdown_menu/dropdown_menu.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DropdownMenuController controller;

  @override
  void initState() {
    controller = new DropdownMenuController();
    super.initState();
  }

  Widget buildMenuItem() {
    return new SizedBox(
      height: 45.0,
      child: new Row(
        children: <Widget>[
          new Text(
              "Random menu data" + new math.Random().nextInt(1000).toString()),
        ],
      ),
    );
  }

  Widget buildMenu(int maxHeight) {
    List<Widget> list = [];

    int len = 5 + new math.Random().nextInt(5);

    double height = math.min(maxHeight * 0.8, len * 45.0);

    for (int i = 0; i < len; ++i) {
      list.add(buildMenuItem());
    }

    return new SizedBox(
      height: height,
      child: new ListView(children: list),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    int maxHeight = data.size.height.toInt() - 100;

    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text(widget.title),
        ),
        body: new SizedBox(
            height: data.size.height,
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new FlatButton(
                        onPressed: () {
                          controller.show(0);
                        },
                        child: new Text("show0")),
                    new FlatButton(
                        onPressed: () {
                          controller.show(1);
                        },
                        child: new Text("show1")),
                    new FlatButton(
                        onPressed: () {
                          controller.show(2);
                        },
                        child: new Text("show2")),
                    new FlatButton(
                        onPressed: () {
                          controller.hide();
                        },
                        child: new Text("hide")),
                  ],
                ),
                new Expanded(
                  child: new DropdownMenu(
                    menus: [
                      buildMenu(maxHeight),
                      buildMenu(maxHeight),
                      new DropdownMenuBuilder(
                          builder: (BuildContext context) {
                            return new AsyncLoader(
                              initState: () {
                                return new Future.delayed(
                                    new Duration(milliseconds: 2000));
                              },
                              renderLoad: () {
                                return new Center(
                                  child: new CircularProgressIndicator(),
                                );
                              },
                              renderSuccess: ({data}) {
                                return new Center(
                                  child: new Text("This is my menu loaded!"),
                                );
                              },
                              renderError: ([error]) {},
                            );
                          },
                          height: maxHeight * 0.8.toDouble())
                    ],
                    controller: controller,
                    switchStyle: DropdownMenuShowHideSwitchStyle.directHideAnimationShow,
                    child: new ListView(
                      children:
                          [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((dynamic i) {
                        return new InkWell(
                            onTap: () {
                              print(new DateTime.now());
                            },
                            child: new Padding(
                                padding: new EdgeInsets.all(10.0),
                                child: new Text("Fake content")));
                      }).toList(),
                    ),
                  ),
                )
              ],
            )));
  }
}
