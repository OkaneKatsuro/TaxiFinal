import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../buttons/button2.dart';
import '../buttons/button3.dart';

void selectRouteDialog(Widget child, Function cancel, BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => SafeArea(
      child: Dismissible(
        key: const Key('key'),
        direction: DismissDirection.down,
        onDismissed: (_) => Navigator.of(context).pop(),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          //  height: MediaQuery.of(context).size.height - 20,
          padding: const EdgeInsets.only(top: 20.0),
          margin: EdgeInsets.only(
            top: 20,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: child,
          ),
        ),
      ),
    ),
  );
}
