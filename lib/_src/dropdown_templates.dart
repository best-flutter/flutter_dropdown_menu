import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

import 'package:dropdown_menu/_src/dropdown_header.dart';

Widget buildCheckItem(BuildContext context, dynamic data, bool selected) {
  return new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new Row(
        children: <Widget>[
          new Text(
            defaultGetItemLabel(data),
            style: selected
                ? new TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400)
                : new TextStyle(fontSize: 14.0),
          ),
          new Expanded(
              child: new Align(
            alignment: Alignment.centerRight,
            child: selected
                ? new Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                  )
                : null,
          )),
        ],
      ));
}
