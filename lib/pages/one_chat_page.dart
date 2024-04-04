import 'dart:async';
import 'dart:convert';

import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/models/message.dart';
import 'package:cars/models/role.dart';
import 'package:cars/pages/chats_page.dart';
import 'package:cars/res/firebase_utils.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../bloc/user/user_cubit.dart';
import '../res/notification_services.dart';
import '../res/styles.dart';

class OneChatPage extends StatefulWidget {
  OneChatPage({
    Key? key,
    required this.passId,
    required this.driverId,
    required this.oneId,
  }) : super(key: key);

  final String passId;
  final String driverId;
  final String oneId;

  @override
  State<OneChatPage> createState() => _OneChatPageState();
}

class _OneChatPageState extends State<OneChatPage> {
  late TextEditingController comment;
  late UserCubit userCubit;
  late StreamSubscription<QuerySnapshot> subscription;
  late ScrollController controller;
  late TextEditingController textController;

  String message = '';
  bool isWaiting = false;
  List<Message> list = [];

  @override
  void initState() {
    super.initState();
    comment = TextEditingController(
      text: context.read<RouteFromToCubit>().get().comment ?? '',
    );
    userCubit = context.read<UserCubit>();
    controller = ScrollController();
    textController = TextEditingController();

    subscription = FirebaseFirestore.instance
        .collection('chats')
        .doc('${widget.passId}-${widget.driverId}')
        .collection('messages')
        .snapshots()
        .listen((querySnapshot) {
      print("UPPPDATE");
      var listTmp = querySnapshot.docs.toList();
      if (listTmp.length > 20) {
        listTmp = querySnapshot.docs.toList().sublist(querySnapshot.docs.toList().length - 20);
      }

      setState(() {
        list.clear();
        list.addAll(listTmp.map((doc) => Message.fromJson(doc.data().values.first)));
      });

      print(list);

      Future.delayed(Duration(milliseconds: 500), () {
        controller.jumpTo(controller.position.maxScrollExtent);
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

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
                    onTap: () => Get.to(ChatsPage()),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  Expanded(child: SizedBox()),
                  Text(
                    'Чат с ${userCubit.getUser()!.role == Role.pass ? 'водителем' : 'пассажиром'}',
                    style: h17w500Black,
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            SizedBox(height: 15),
            MyDivider(),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                controller: controller,
                children: [
                  ...list.map((e) => _buildMessage(e)).toList(),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: 5),
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) => setState(() {
                        message = value;
                      }),
                      scrollPadding: EdgeInsets.only(right: 4),
                      scrollController: controller,
                      maxLines: 4,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Сообщение...',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                if (message != '')
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          isWaiting = true;
                        });

                        String playerId = widget.oneId;
                        await sendMessage(
                          passId: widget.passId,
                          driverId: widget.driverId,
                          message: Message(
                            date: DateTime.now().millisecondsSinceEpoch,
                            senderId: userCubit.getUser()!.id,
                            senderName: '${userCubit.getUser()!.fname} ${userCubit.getUser()!.lname}',
                            message: message,
                          ),
                        );

                        await sendNotification(
                          [playerId],
                          message,
                          '${userCubit.getUser()!.fname} ${userCubit.getUser()!.lname}',
                        );

                        FocusManager.instance.primaryFocus?.unfocus();

                        setState(() {
                          isWaiting = false;
                          message = '';
                          textController.clear();
                        });
                      },
                      child: isWaiting
                          ? CircularProgressIndicator()
                          : CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(Message message) {
    return Column(
      crossAxisAlignment: userCubit.getUser()!.id == message.senderId ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          alignment: userCubit.getUser()!.id == message.senderId ? Alignment.topRight : Alignment.topLeft,
          child: Text(
            DateTime(
              DateTime.fromMillisecondsSinceEpoch(message.date).year,
              DateTime.fromMillisecondsSinceEpoch(message.date).month,
              DateTime.fromMillisecondsSinceEpoch(message.date).day,
            ) ==
                DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                )
                ? DateFormat('hh:mm').format(DateTime.fromMillisecondsSinceEpoch(message.date))
                : DateFormat('hh:mm, dd MMM').format(DateTime.fromMillisecondsSinceEpoch(message.date)),
            style: h12w400BlackWithOpacity,
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 150),
          child: Container(
            margin: EdgeInsets.only(
              top: 5,
              bottom: 20,
              left: userCubit.getUser()!.id == message.senderId ? 50 : 10,
              right: userCubit.getUser()!.id == message.senderId ? 10 : 50,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(userCubit.getUser()!.id == message.senderId ? 25 : 0),
                bottomRight: Radius.circular(userCubit.getUser()!.id == message.senderId ? 0 : 25),
              ),
              color: userCubit.getUser()!.id == message.senderId ? Colors.blue : Colors.grey.shade200,
            ),
            child: Text(
              message.message,
              style: h13w500Black.copyWith(color: userCubit.getUser()!.id == message.senderId ? Colors.white : null),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> sendNotification(List<String> tokenIdList, String contents, String heading) async {
  final String kAppId = "44659ce6-937c-4e6f-a97c-9893a3ed5f02";
  final String oneSignalUrl = 'https://onesignal.com/api/v1/notifications';

  try {
    await http.post(
      Uri.parse(oneSignalUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": kAppId,
        "include_player_ids": tokenIdList,
        "android_accent_color": "FF9976D2",
        "small_icon": "ic_stat_onesignal_default",
        "large_icon": "https://i.ibb.co/DRNmm9Y/icon.png",
        "headings": {"en": heading},
        "contents": {"en": contents},
      }),
    );
  } catch (e) {
    print('Error sending notification: $e');
    throw e;
  }
}
