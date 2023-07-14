import 'package:flutter/material.dart';

import 'package:dropdown_menu/_src/dropdown_header.dart';

Widget buildCheckItem(BuildContext context, dynamic data, bool selected) {
  return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              defaultGetItemLabel(data)!,
              style: selected
                  ? TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w400)
                  : const TextStyle(fontSize: 14.0),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: selected
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                  )
                : null,
          ),
        ],
      ));
}
