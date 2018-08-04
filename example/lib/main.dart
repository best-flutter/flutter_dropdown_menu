import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dropdown_menu/dropdown_menu.dart';
import 'dart:math' as math;
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
          primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white),
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

const List<Map<String, dynamic>> ORDERS = [
  {"title": "综合排序"},
  {"title": "好评优先"},
  {"title": "离我最近"},
  {"title": "人气最高"},
];

const int ORDER_INDEX = 0;

const List<Map<String, dynamic>> TYPES = [
  {"title": "全部", "id": 0},
  {"title": "甜点饮品", "id": 1},
  {"title": "生日蛋糕", "id": 2},
  {"title": "火锅", "id": 3},
  {"title": "自助餐", "id": 4},
  {"title": "小吃", "id": 5},
  {"title": "快餐", "id": 6},
  {"title": "日韩料理", "id": 7},
  {"title": "西餐", "id": 8},
  {"title": "聚餐", "id": 9},
  {"title": "烧烤", "id": 10},
  {"title": "川菜", "id": 11},
  {"title": "江浙菜", "id": 12},
  {"title": "东北菜", "id": 13},
  {"title": "蒙餐", "id": 14},
  {"title": "新疆菜", "id": 15},
];

const int TYPE_INDEX = 2;

const List<Map<String, dynamic>> BUSINESS_CYCLE = [
  {
    "title": "附近",
    "children": [
      {"title": "附近", "distance": 500},
      {"title": "1km", "distance": 1000},
      {"title": "2km", "distance": 2000}
    ]
  },
  {
    "title": "推荐商圈",
    "children": [
      {"title": "中山路", "count": 326},
      {"title": "万达广场", "count": 100},
      {"title": "瑞景", "count": 50}
    ]
  },
  {
    "title": "附近",
    "children": [
      {"title": "附近", "distance": 500},
      {"title": "1km", "distance": 1000},
      {"title": "2km", "distance": 2000}
    ]
  },
  {
    "title": "附近",
    "children": [
      {"title": "附近", "distance": 500},
      {"title": "1km", "distance": 1000},
      {"title": "2km", "distance": 2000}
    ]
  },
];

String FOOD_JSON =
    '[{"title":"力体","children":[{"title":"传声织","count":810},{"title":"分队什","count":463},{"title":"且工","count":325},{"title":"清局","count":899},{"title":"代老克","count":325},{"title":"持连回","count":14},{"title":"改层听","count":470},{"title":"存比","count":908},{"title":"热土米","count":333},{"title":"水发","count":58},{"title":"制见","count":28},{"title":"取化无","count":469},{"title":"记有何","count":503},{"title":"亲公何","count":930},{"title":"步业要","count":885}]},{"title":"建易外","children":[{"title":"生观真","count":207},{"title":"音代","count":425},{"title":"族王资","count":205},{"title":"圆传统","count":791},{"title":"些任","count":141},{"title":"程即走","count":163},{"title":"各七","count":65},{"title":"院此格","count":314},{"title":"支及","count":726},{"title":"别题","count":524},{"title":"低去到","count":706},{"title":"般将","count":13},{"title":"西南","count":189},{"title":"状南制","count":335},{"title":"调油","count":90},{"title":"听从没","count":33},{"title":"电求什","count":88}]},{"title":"非先算","children":[{"title":"严状","count":108},{"title":"查增","count":634},{"title":"号备","count":304},{"title":"法口群","count":304},{"title":"半电报","count":324},{"title":"线红","count":153},{"title":"信证作","count":546},{"title":"器电","count":651},{"title":"示南称","count":128},{"title":"全战","count":412},{"title":"走打","count":592},{"title":"眼基般","count":134},{"title":"来究计","count":322},{"title":"性们","count":511},{"title":"儿数金","count":427},{"title":"已计","count":593},{"title":"导养","count":973}]},{"title":"头走认","children":[{"title":"导时","count":229},{"title":"达积且","count":277},{"title":"样队儿","count":592},{"title":"电历","count":568},{"title":"车一","count":618},{"title":"求生研","count":886},{"title":"正将","count":300},{"title":"并米论","count":945},{"title":"压进到","count":320},{"title":"具候素","count":607},{"title":"它长","count":411},{"title":"写非","count":716},{"title":"实员产","count":452},{"title":"资参管","count":561},{"title":"八主","count":748},{"title":"事厂要","count":672},{"title":"命面","count":83},{"title":"任天","count":106}]},{"title":"机列二","children":[{"title":"展花","count":426},{"title":"经报导","count":363},{"title":"分带完","count":767},{"title":"于却安","count":687},{"title":"她回别","count":520},{"title":"根层性","count":853},{"title":"历感","count":532},{"title":"大响三","count":573},{"title":"本住","count":893},{"title":"际志","count":466},{"title":"温金起","count":231},{"title":"山温","count":910},{"title":"把程","count":463},{"title":"出交认","count":232}]},{"title":"其造据","children":[{"title":"满成风","count":49},{"title":"正世龙","count":385},{"title":"命出","count":142},{"title":"真区","count":736},{"title":"压平马","count":780},{"title":"交飞省","count":876},{"title":"集处就","count":694},{"title":"车便","count":410},{"title":"样装性","count":713},{"title":"斯更","count":425},{"title":"响许","count":975},{"title":"能目设","count":778},{"title":"近准","count":974},{"title":"参音","count":252},{"title":"教见","count":611},{"title":"问素","count":883},{"title":"连也","count":265},{"title":"飞采","count":448},{"title":"法那且","count":748},{"title":"区决门","count":173}]},{"title":"东么","children":[{"title":"近华","count":875},{"title":"极何现","count":576},{"title":"叫条等","count":501},{"title":"办市","count":344},{"title":"无组便","count":177},{"title":"义料","count":728},{"title":"声米","count":743},{"title":"进论书","count":670},{"title":"土九","count":339},{"title":"山矿","count":560},{"title":"一参","count":303}]},{"title":"老农","children":[{"title":"总计工","count":667},{"title":"验义风","count":456},{"title":"业导低","count":802},{"title":"音速是","count":26},{"title":"器众","count":869},{"title":"争才","count":775},{"title":"面听三","count":635},{"title":"拉后","count":293},{"title":"也按","count":339},{"title":"没式其","count":673},{"title":"酸细","count":405},{"title":"平后","count":302},{"title":"给气","count":269},{"title":"持后","count":864},{"title":"月次","count":561},{"title":"一者","count":36},{"title":"名问当","count":600},{"title":"马该","count":785},{"title":"为列","count":915}]},{"title":"局点自","children":[{"title":"什深求","count":399},{"title":"时么","count":514},{"title":"果放北","count":638},{"title":"导片","count":622},{"title":"第该打","count":353},{"title":"队深决","count":526},{"title":"器低县","count":626},{"title":"花正不","count":98},{"title":"难要江","count":111},{"title":"质市","count":241},{"title":"快强又","count":429},{"title":"细与","count":624},{"title":"证厂","count":922},{"title":"新调业","count":302},{"title":"开圆","count":35}]},{"title":"近从","children":[{"title":"改然","count":396},{"title":"受为","count":17},{"title":"受口","count":262},{"title":"与全大","count":25},{"title":"拉总","count":149},{"title":"代打题","count":171},{"title":"主造出","count":163},{"title":"最交能","count":922},{"title":"高五","count":786},{"title":"开革","count":12},{"title":"名情","count":990},{"title":"级油","count":818},{"title":"温办始","count":431},{"title":"济地节","count":330},{"title":"象龙","count":233}]}]';

List FOODS = json.decode(FOOD_JSON);

const int FOOD_INDEX = 1;

class _MyHomePageState extends State<MyHomePage> {
  ScrollController scrollController;
  @override
  void initState() {
    scrollController = new ScrollController();
    globalKey = new GlobalKey();
    super.initState();
  }

  DropdownMenu buildDropdownMenu() {
    return new DropdownMenu(maxMenuHeight: kDropdownMenuItemHeight * 10,
        //  activeIndex: activeIndex,
        menus: [
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: TYPE_INDEX,
                  data: TYPES,
                  itemBuilder: buildCheckItem,
                );
              },
              height: kDropdownMenuItemHeight * TYPES.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: ORDER_INDEX,
                  data: ORDERS,
                  itemBuilder: buildCheckItem,
                );
              },
              height: kDropdownMenuItemHeight * ORDERS.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownTreeMenu(
                  selectedIndex: 0,
                  subSelectedIndex: 0,
                  itemExtent: 45.0,
                  background: Colors.red,
                  subBackground: Colors.blueAccent,
                  itemBuilder:
                      (BuildContext context, dynamic data, bool selected) {
                    if (!selected) {
                      return new DecoratedBox(
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: Divider.createBorderSide(context))),
                          child: new Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: new Row(
                                children: <Widget>[
                                  new Text(data['title']),
                                ],
                              )));
                    } else {
                      return new DecoratedBox(
                          decoration: new BoxDecoration(
                              border: new Border(
                                  top: Divider.createBorderSide(context),
                                  bottom: Divider.createBorderSide(context))),
                          child: new Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: new Row(
                                children: <Widget>[
                                  new Container(
                                      color: Theme.of(context).primaryColor,
                                      width: 3.0,
                                      height: 20.0),
                                  new Padding(
                                      padding: new EdgeInsets.only(left: 12.0),
                                      child: new Text(data['title'])),
                                ],
                              )));
                    }
                  },
                  subItemBuilder:
                      (BuildContext context, dynamic data, bool selected) {
                    Color color = selected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.body1.color;

                    return new SizedBox(
                      height: 45.0,
                      child: new Row(
                        children: <Widget>[
                          new Text(
                            data['title'],
                            style: new TextStyle(color: color),
                          ),
                          new Expanded(
                              child: new Align(
                                  alignment: Alignment.centerRight,
                                  child: new Text(data['count'].toString())))
                        ],
                      ),
                    );
                  },
                  getSubData: (dynamic data) {
                    return data['children'];
                  },
                  data: FOODS,
                );
              },
              height: 450.0)
        ]);
  }

  DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
    return new DropdownHeader(
      onTap: onTap,
      titles: [TYPES[TYPE_INDEX], ORDERS[ORDER_INDEX], FOODS[0]['children'][0]],
    );
  }

  Widget buildFixHeaderDropdownMenu() {
    return new DefaultDropdownMenuController(
        child: new Column(
      children: <Widget>[
        buildDropdownHeader(),
        new Expanded(
            child: new Stack(
          children: <Widget>[
            new ListView(
              children: <Widget>[new Text("123123")],
            ),
            buildDropdownMenu()
          ],
        ))
      ],
    ));
  }

  Widget buildInnerListHeaderDropdownMenu() {
    return new DefaultDropdownMenuController(
        onSelected: ({int menuIndex, int index, int subIndex, dynamic data}) {
          print(
              "menuIndex:$menuIndex index:$index subIndex:$subIndex data:$data");
        },
        child: new Stack(
          children: <Widget>[
            new CustomScrollView(
                controller: scrollController,
                slivers: <Widget>[
                  new SliverList(
                      key: globalKey,
                      delegate: new SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return new Container(
                          color: Colors.black26,
                          child: new Image.asset(
                            "images/header.jpg",
                            fit: BoxFit.fill,
                          ),
                        );
                      }, childCount: 1)),
                  new SliverPersistentHeader(
                    delegate: new DropdownSliverChildBuilderDelegate(
                        builder: (BuildContext context) {
                      return new Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: buildDropdownHeader(onTap: this._onTapHead));
                    }),
                    pinned: true,
                    floating: true,
                  ),
                  new SliverList(
                      delegate: new SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                    return new Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: new Image.asset(
                        "images/body.jpg",
                        fit: BoxFit.fill,
                      ),
                    );
                  }, childCount: 10)),
                ]),
            new Padding(
                padding: new EdgeInsets.only(top: 46.0),
                child: buildDropdownMenu())
          ],
        ));
  }

  GlobalKey globalKey;
  @override
  void dispose() {
    super.dispose();
  }

  void _onTapHead(int index) {
    RenderObject renderObject = globalKey.currentContext.findRenderObject();
    DropdownMenuController controller =
        DefaultDropdownMenuController.of(globalKey.currentContext);
    //
    scrollController
        .animateTo(scrollController.offset + renderObject.semanticBounds.height,
            duration: new Duration(milliseconds: 150), curve: Curves.ease)
        .whenComplete(() {
      controller.show(index);
    });
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: _currentIndex == 0
          ? buildFixHeaderDropdownMenu()
          : buildInnerListHeaderDropdownMenu(),
      bottomNavigationBar: new BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          items: [
            {"name": "Fix", "icon": Icons.hearing},
            {"name": "ScrollView", "icon": Icons.list}
          ]
              .map((dynamic data) => new BottomNavigationBarItem(
                  title: new Text(data["name"]), icon: new Icon(data["icon"])))
              .toList()),
    );
  }
}
