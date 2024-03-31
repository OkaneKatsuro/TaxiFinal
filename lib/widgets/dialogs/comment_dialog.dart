import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../buttons/button2.dart';
import '../buttons/button3.dart';

void commentDialog(Widget child, Function cancel, BuildContext context) {
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
          height: MediaQuery.of(context).viewInsets.bottom > 30
              ? MediaQuery.of(context).size.height - 20
              : 400,
          padding: const EdgeInsets.only(top: 20.0),
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).viewInsets.bottom > 30 ? 10 : 300,
          ),
          child: Scaffold(
            body: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}
