import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../res/styles.dart';

class Button1 extends StatelessWidget {
  Button1({super.key, required this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteGrey2,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Text(
        title,
        style: h13w500Black,
      ),
    );
  }
}
