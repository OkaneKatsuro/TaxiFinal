import 'dart:async';

import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/models/message.dart';
import 'package:cars/models/role.dart';
import 'package:cars/pages/chats_page.dart';
import 'package:cars/res/firebase_utils.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../res/chat_notification_controller.dart';
import '../res/styles.dart';

class OneChatPage extends StatefulWidget {
  OneChatPage({
    Key? key,
    required this.passId,
    required this.driverId,
  }) : super(key: key);

  final String passId;
  final String driverId;

  @override
  State<OneChatPage> createState() => _OneChatPageState();
}

class _OneChatPageState extends State<OneChatPage> with WidgetsBindingObserver {
  late TextEditingController comment;
  late StreamSubscription<QuerySnapshot>? s;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    comment = TextEditingController(
        text: context.read<RouteFromToCubit>().get().comment ?? '');

    s = FirebaseFirestore.instance
        .collection('chats')
        .doc('${widget.passId}-${widget.driverId}')
        .collection('messages')
        .snapshots()
        .listen((querySnapshot) async {
      print("UPDATE");
      var listTmp = querySnapshot.docs.toList();
      if (listTmp.length > 20) {
        listTmp = querySnapshot.docs
            .toList()
            .sublist(querySnapshot.docs.toList().length - 20);
      }

      var newMessages = <Message>[];

      listTmp.forEach((element) {
        final data = element.data().values.first;
        if (data != null) {
          final messageData = Message.fromJson(data);
          if (!list.any((message) =>
          message.date == messageData.date &&
              message.senderId == messageData.senderId &&
              message.message == messageData.message)) {
            newMessages.add(messageData);
            list.add(messageData);
          }
        }
      });

      setState(() {});

      Future.delayed(Duration(milliseconds: 500), () {
        controller.jumpTo(controller.position.maxScrollExtent);
      });

      if (newMessages.isNotEmpty) {
        final currentUserID = context.read<UserCubit>().getUser()!.id;
        final sender = newMessages.last.senderName;

        final lastM = newMessages.last;

        if (currentUserID != lastM.senderId) {
          ChatNotificationController.sendChatNotification(
            sender: sender,
            message: lastM.message,
          );
        }
      }
    });
  }

  final scrollController = ScrollController();
  String message = '';
  bool isWaiting = false;
  final textcontroller = TextEditingController();
  List<Message> list = [];
  var controller = ScrollController();

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    s?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print("App Resumed");
      // Handle app resumed state
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Возвращаем автоматическое поднятие содержимого при открытии клавиатуры
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
                    'Чат с ${context.read<UserCubit>().getUser()!.role == Role.pass ? 'водителем ' : 'пассажиром'}',
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
              child: ListView.builder(
                controller: controller,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final e = list[index];
                  return Column(
                    crossAxisAlignment: context.read<UserCubit>().getUser()!.id == e.senderId
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        alignment: context.read<UserCubit>().getUser()!.id == e.senderId
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: Text(
                          DateTime(
                              DateTime.fromMillisecondsSinceEpoch(e.date).year,
                              DateTime.fromMillisecondsSinceEpoch(e.date).month,
                              DateTime.fromMillisecondsSinceEpoch(e.date).day) ==
                              DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                              ? DateFormat('hh:mm').format(DateTime.fromMillisecondsSinceEpoch(e.date))
                              : DateFormat('hh:mm, dd MMM').format(DateTime.fromMillisecondsSinceEpoch(e.date)),
                          style: h12w400BlackWithOpacity,
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 150),
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 5,
                              bottom: 20,
                              left: context.read<UserCubit>().getUser()!.id == e.senderId ? 50 : 10,
                              right: context.read<UserCubit>().getUser()!.id == e.senderId ? 10 : 50),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(context.read<UserCubit>().getUser()!.id == e.senderId ? 25 : 0),
                              bottomRight: Radius.circular(context.read<UserCubit>().getUser()!.id == e.senderId ? 0 : 25),
                            ),
                            color: context.read<UserCubit>().getUser()!.id == e.senderId ? blue : whiteGrey2,
                          ),
                          child: Text(
                            e.message,
                            style: h13w500Black.copyWith(color: context.read<UserCubit>().getUser()!.id == e.senderId ? Colors.white : null),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: 5),
                Expanded(
                  child: Container(
                    child: Scrollbar(
                      child: TextField(
                        controller: textcontroller,
                        onChanged: (value) => setState(() {
                          message = value;
                        }),
                        decoration: InputDecoration(
                          hintText: 'Сообщение...', // Добавляем текст в поле ввода
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.5, color: Colors.grey),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.5, color: Colors.grey),
                              borderRadius: BorderRadius.circular(20)
                          ),
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
                        await sendMessage(
                          passId: widget.passId,
                          driverId: widget.driverId,
                          message: Message(
                            date: DateTime.now().millisecondsSinceEpoch,
                            senderId: context.read<UserCubit>().getUser()!.id,
                            senderName: context.read<UserCubit>().getUser()!.fname + ' ' + context.read<UserCubit>().getUser()!.lname,
                            message: message,
                          ),
                        );
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          isWaiting = false;
                          message = '';
                          textcontroller.clear();
                        });
                      },
                      child: isWaiting
                          ? CircularProgressIndicator()
                          : CircleAvatar(
                        backgroundColor: blue,
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
}