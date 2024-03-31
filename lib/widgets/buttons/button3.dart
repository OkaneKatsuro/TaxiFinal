import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../res/styles.dart';

class Button3 extends StatelessWidget {
  Button3({super.key, required this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteGrey3,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Text(
        title,
        style: h14w500Black,
      ),
    );
  }
}
