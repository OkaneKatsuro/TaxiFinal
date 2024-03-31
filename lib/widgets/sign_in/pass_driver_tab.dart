import 'package:flutter/material.dart';
import '../../models/role.dart';
import '../../models/user.dart';
import '../../res/styles.dart';

class PassDriverTab extends StatelessWidget {
  PassDriverTab({super.key, required this.role, required this.change});
  Role role;
  Function change;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: whiteGrey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => change(Role.pass),
            child: Container(
              alignment: Alignment.center,
              height: 41,
              width: 140,
              decoration: role == Role.pass
                  ? BoxDecoration(
                      color: blue, borderRadius: BorderRadius.circular(10))
                  : null,
              child: Text(
                'Пассажир',
                style: role == Role.pass ? h13w500White : h13w500Black,
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () => change(Role.driver),
            child: Container(
              alignment: Alignment.center,
              height: 41,
              width: 140,
              decoration: role == Role.driver
                  ? BoxDecoration(
                      color: blue, borderRadius: BorderRadius.circular(10))
                  : null,
              child: Text(
                'Водитель',
                style: role == Role.driver ? h13w500White : h13w500Black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
