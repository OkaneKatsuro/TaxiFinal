import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/models/message.dart';
import 'package:cars/models/role.dart';
import 'package:cars/pages/driver_home_page.dart';
import 'package:cars/pages/one_chat_page.dart';
import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/res/firebase_utils.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/chat/chat_select_fake.dart';
import 'package:cars/widgets/chat/one_chat_fake.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../bloc/user/user_cubit.dart';
import '../res/styles.dart';

class ChatsPage extends StatefulWidget {
  ChatsPage({
    super.key,
  });

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  var comment = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    () async {
      var tmp = await getUserList(context.read<UserCubit>().getUser()!.role);
      setState(() {
        if (tmp != null) map = tmp;
      });

      FirebaseFirestore.instance
          .collection('chats')
          .snapshots()
          .listen((event) {
        print('EVENTTTTT');
        print(context.read<UserCubit>().getUser()!.role);
        map.entries.forEach((element) async {
          var nm = context.read<UserCubit>().getUser()!.role == Role.pass
              ? context.read<UserCubit>().getUser()!.id + '-' + element.key
              : element.key + '-' + context.read<UserCubit>().getUser()!.id;
          print('');

          //get last msg
          var m = await getLastMessage(docId: nm);
          lastMess.addAll({nm: m});
          setState(() {});
        });
      });
    }();
  }

  Map<String, Message?> lastMess = {};

  var list;

  Map<String, String> map = {};
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
                    onTap: () => Get.offAll(
        context.read<UserCubit>().getUser()!.role == Role.driver
            ? DriverHomePage()
            : PassHomePage(),
        predicate: (route) => false,
      ),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  Expanded(child: SizedBox()),
                  Text(
                    'Чаты с ${context.read<UserCubit>().getUser()!.role == Role.driver ? 'пассажирами' : 'водителями'}',
                    style: h17w500Black,
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            SizedBox(height: 15),
            MyDivider(),
            SizedBox(height: 20),
            ...map.entries.map((e) {
              var nm = context.read<UserCubit>().getUser()!.role == Role.pass
                  ? context.read<UserCubit>().getUser()!.id + '-' + e.key
                  : e.key + '-' + context.read<UserCubit>().getUser()!.id;

              return InkWell(
                onTap: () {
                  print(context.read<UserCubit>().getUser()!.id);
                  if (context.read<UserCubit>().getUser()!.role == Role.pass) {
                    Get.to(OneChatPage(
                        passId: context.read<UserCubit>().getUser()!.id,
                        driverId: e.key,
                        oneId: map[e.key]!));
                  } else {
                    Get.to(OneChatPage(
                        driverId: context.read<UserCubit>().getUser()!.id,
                        passId: e.key,
                        oneId: map[e.key]!));
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: 70,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor:
                            const Color.fromARGB(255, 231, 229, 229),
                            child: Text(e.value.substring(0, 1)),
                          ),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.value),
                              Text(
                                lastMess[nm]?.message ?? '',
                                style: h12w400BlackWithOpacity,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 30,
                      top: 20,
                      child: Text(
                          lastMess[nm] != null
                              ? DateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  lastMess[nm]!.date)
                                  .year,
                              DateTime.fromMillisecondsSinceEpoch(
                                  lastMess[nm]!.date)
                                  .month,
                              DateTime.fromMillisecondsSinceEpoch(
                                  lastMess[nm]!.date)
                                  .day) ==
                              DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day)
                              ? DateFormat('hh:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  lastMess[nm]!.date))
                              : DateFormat('hh:mm, dd MMM').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  lastMess[nm]!.date))
                              : '',
                          style: h12w400BlackWithOpacity),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}