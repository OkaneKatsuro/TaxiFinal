import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/models/role.dart';
import 'package:cars/res/firebase_utils.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../models/car_order.dart';
import '../res/styles.dart';
import '../widgets/planing/planing_container.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({
    super.key,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var comment = TextEditingController();

  @override
  void initState() {
    print('init');
    comment = TextEditingController(
        text: context.read<RouteFromToCubit>().get().comment ?? '');
    () async {
      print(context.read<UserCubit>().getUser()!.id);
      var tmp = await getHistory(context);
      if (tmp != null) {
        setState(() {
          orderList = tmp;
        });
      }
    }();
    super.initState();
  }

  List<CarOrder> orderList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              width: double.infinity,
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios, color: black),
                  ),
                  Expanded(child: SizedBox()),
                  Text(
                    'История поездок',
                    style: h17w500Black,
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            SizedBox(height: 15),
            MyDivider(),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...orderList.map(
                      (e) => PlaningContainer(
                        isHistory: true,
                        name:
                            context.read<UserCubit>().getUser()!.role == Role.driver
                                ? e.passName ?? ''
                                : e.driverName ?? '',
                        route: [
                          e.from!,
                          ...e.route ?? [],
                        ],
                        startDate: e.startDate!,
                        endDate: e.endDate!,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
