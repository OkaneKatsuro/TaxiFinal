import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../res/styles.dart';

void pageDialog(BuildContext context, Function dismis, Widget child) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => SafeArea(
      child: Dismissible(
        key: const Key('key'),
        direction: DismissDirection.down,
        onDismissed: (_) => dismis(),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          //  height: MediaQuery.of(context).

          margin: EdgeInsets.only(
              // top: MediaQuery.of(context).viewInsets.bottom > 30 ? 10 : 300,
              ),
          child: Scaffold(
              body: Container(
            color: Colors.white,
            width: double.infinity,
            child: child,
          )),
        ),
      ),
    ),
  );
}
