import 'package:flutter/material.dart';

import '../../../res/styles.dart';

class SearchRow extends StatelessWidget {
  SearchRow({
    super.key,
    required this.firstString,
    required this.secnodString,
    required this.icon,
  });
  String firstString;
  String secnodString;
  Widget icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              child: Text(
                firstString,
                style: h13w500Black,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (secnodString != '')
              SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                child: Text(
                  secnodString,
                  style: h12w400BlackWithOpacity,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
