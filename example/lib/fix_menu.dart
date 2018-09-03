//
//DropdownMenu buildDropdownMenu() {
//  return new DropdownMenu(maxMenuHeight: kDropdownMenuItemHeight * 10,
//      //  activeIndex: activeIndex,
//      menus: [
//        new DropdownMenuBuilder(
//            builder: (BuildContext context) {
//              return new DropdownListMenu(
//                selectedIndex: TYPE_INDEX,
//                data: TYPES,
//                itemBuilder: buildCheckItem,
//              );
//            },
//            height: kDropdownMenuItemHeight * TYPES.length),
//        new DropdownMenuBuilder(
//            builder: (BuildContext context) {
//              return new DropdownListMenu(
//                selectedIndex: ORDER_INDEX,
//                data: ORDERS,
//                itemBuilder: buildCheckItem,
//              );
//            },
//            height: kDropdownMenuItemHeight * ORDERS.length),
//        new DropdownMenuBuilder(builder: (BuildContext context) {
//          return new DropdownTreeMenu(
//            selectedIndex: 0,
//            subSelectedIndex: 0,
//            itemExtent: 45.0,
//            background: Colors.red,
//            subBackground: Colors.blueAccent,
//            itemBuilder: (BuildContext context, dynamic data, bool selected) {
//              if (!selected) {
//                return new DecoratedBox(
//                    decoration: new BoxDecoration(
//                        border: new Border(
//                            right: Divider.createBorderSide(context))),
//                    child: new Padding(
//                        padding: const EdgeInsets.only(left: 15.0),
//                        child: new Row(
//                          children: <Widget>[
//                            new Text(data['title']),
//                          ],
//                        )));
//              } else {
//                return new DecoratedBox(
//                    decoration: new BoxDecoration(
//                        border: new Border(
//                            top: Divider.createBorderSide(context),
//                            bottom: Divider.createBorderSide(context))),
//                    child: new Container(
//                        color: Theme.of(context).scaffoldBackgroundColor,
//                        child: new Row(
//                          children: <Widget>[
//                            new Container(
//                                color: Theme.of(context).primaryColor,
//                                width: 3.0,
//                                height: 20.0),
//                            new Padding(
//                                padding: new EdgeInsets.only(left: 12.0),
//                                child: new Text(data['title'])),
//                          ],
//                        )));
//              }
//            },
//            subItemBuilder:
//                (BuildContext context, dynamic data, bool selected) {
//              Color color = selected
//                  ? Theme.of(context).primaryColor
//                  : Theme.of(context).textTheme.body1.color;
//
//              return new SizedBox(
//                height: 45.0,
//                child: new Row(
//                  children: <Widget>[
//                    new Text(
//                      data['title'],
//                      style: new TextStyle(color: color),
//                    ),
//                    new Expanded(
//                        child: new Align(
//                            alignment: Alignment.centerRight,
//                            child: new Text(data['count'].toString())))
//                  ],
//                ),
//              );
//            },
//            getSubData: (dynamic data) {
//              return data['children'];
//            },
//            data: FOODS,
//
//          );
//        },height: 450.0)
//      ]);
//}
//
//DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
//  return new DropdownHeader(
//    onTap: onTap,
//    titles: [TYPES[TYPE_INDEX], ORDERS[ORDER_INDEX], FOODS[0]['children'][0]],
//  );
//}
//
//Widget buildFixHeaderDropdownMenu() {
//  return new DefaultDropdownMenuController(
//      child: new Column(
//        children: <Widget>[
//          buildDropdownHeader(),
//          new Expanded(
//              child: new Stack(
//                children: <Widget>[
//                  new ListView(
//                    children: <Widget>[new Text("123123")],
//                  ),
//                  buildDropdownMenu()
//                ],
//              ))
//        ],
//      ));
//}
//
//Widget buildInnerListHeaderDropdownMenu() {
//  return new DefaultDropdownMenuController(
//      onSelected: ({int menuIndex, int index, int subIndex, dynamic data}) {
//        print(
//            "menuIndex:$menuIndex index:$index subIndex:$subIndex data:$data");
//      },
//      child: new Stack(
//        children: <Widget>[
//          new CustomScrollView(
//              controller: scrollController,
//              slivers: <Widget>[
//                new SliverList(
//                    key: globalKey,
//                    delegate: new SliverChildBuilderDelegate(
//                            (BuildContext context, int index) {
//                          return new Container(
//                            color: Colors.black26,
//                            child: new Image.asset(
//                              "images/header.jpg",
//                              fit: BoxFit.fill,
//                            ),
//                          );
//                        }, childCount: 1)),
//                new SliverPersistentHeader(
//                  delegate: new DropdownSliverChildBuilderDelegate(
//                      builder: (BuildContext context) {
//                        return new Container(
//                            color: Theme.of(context).scaffoldBackgroundColor,
//                            child: buildDropdownHeader(onTap: this._onTapHead));
//                      }),
//                  pinned: true,
//                  floating: true,
//                ),
//                new SliverList(
//                    delegate: new SliverChildBuilderDelegate(
//                            (BuildContext context, int index) {
//                          return new Container(
//                            color: Theme.of(context).scaffoldBackgroundColor,
//                            child: new Image.asset(
//                              "images/body.jpg",
//                              fit: BoxFit.fill,
//                            ),
//                          );
//                        }, childCount: 10)),
//              ]),
//          new Padding(
//              padding: new EdgeInsets.only(top: 46.0),
//              child: buildDropdownMenu())
//        ],
//      ));
//}
//
//GlobalKey globalKey;
//
//void _onTapHead(int index) {
//  RenderObject renderObject = globalKey.currentContext.findRenderObject();
//  DropdownMenuController controller =
//  DefaultDropdownMenuController.of(globalKey.currentContext);
//  //
//  scrollController
//      .animateTo(scrollController.offset + renderObject.semanticBounds.height,
//      duration: new Duration(milliseconds: 150), curve: Curves.ease)
//      .whenComplete(() {
//    controller.show(index);
//  });
//}


import 'package:flutter/material.dart';

class FixMenu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _FixMenuState();
  }

}

class _FixMenuState extends State<FixMenu>{
  @override
  Widget build(BuildContext context) {
    return new Container(

    );
  }

}