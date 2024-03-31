import 'package:flutter/material.dart';

import '../../res/styles.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.0,
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: blue,
            spreadRadius: 0.2,
            blurRadius: 1.5,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
