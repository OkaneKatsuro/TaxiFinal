import 'package:flutter/material.dart';

import '../../res/styles.dart';

class BluePoint extends StatelessWidget {
  const BluePoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      alignment: Alignment.center,
      child: CircleAvatar(
        radius: 5,
        backgroundColor: blue,
      ),
    );
  }
}
