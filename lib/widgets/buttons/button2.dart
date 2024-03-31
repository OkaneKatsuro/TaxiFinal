import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../res/styles.dart';

class Button2 extends StatelessWidget {
  Button2({
    super.key,
    required this.title,
    this.isWaiting = false,
  });
  String title;
  bool isWaiting;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isWaiting ? whiteGrey2 : blue,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: isWaiting
          ? SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(),
            )
          : Text(
              title,
              style: h14w500Black.copyWith(color: Colors.white),
            ),
    );
  }
}
