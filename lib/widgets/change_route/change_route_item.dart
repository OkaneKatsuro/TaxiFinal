import 'dart:math';

import 'package:cars/models/place.dart';
import 'package:flutter/material.dart';

import '../../res/styles.dart';
import '../maps/search_form/search_row.dart';
import '../other/blue_point.dart';

class ChangeRouteItem extends StatelessWidget {
  ChangeRouteItem({
    super.key,
    required this.place,
    this.remove,
    this.showRemove = true,
  });
  Function? remove;
  Place place;
  bool showRemove;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 209, 209, 209).withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40,
            alignment: Alignment.center,
            child: SearchRow(
              firstString: place.name,
              secnodString: place.description ?? '',
              icon: BluePoint(),
            ),
          ),
          if (showRemove)
            InkWell(
              onTap: () {
                if (remove != null) remove!();
              },
              child: Icon(Icons.delete, color: black, size: 20),
            ),
        ],
      ),
    );
  }
}
