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
import 'package:shared_preferences/shared_preferences.dart';

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
  List<int> sentMessagesDate = []; // Список дат отправленных сообщений
  late DateTime lastReceivedMessageDate; // Дата и время последнего полученного сообщения

  late TextEditingController textcontroller;
  late String message = '';
  late bool isWaiting = false;

  @override
  void initState() {
    super.initState();
    lastReceivedMessageDate = DateTime.now();
    WidgetsBinding.instance?.addObserver(this);
    comment = TextEditingController(
        text: context.read<RouteFromToCubit>().get().comment ?? '');

    textcontroller = TextEditingController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    s?.cancel();
    textcontroller.dispose();
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

  Future<void> _loadSentMessages() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sentMessagesDate = prefs.getStringList('sent_messages')?.map((str) => int.parse(str))?.toList() ?? [];
    });
  }

  Future<void> _saveSentMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('sent_messages', sentMessagesDate.map((date) => date.toString()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc('${widget.passId}-${widget.driverId}')
                    .collection('messages')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Message> messages = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return Message.fromJson(data.values.first);
                    }).toList();

                    // Handle new messages here and send notifications if needed
                    handleNewMessages(messages);

                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final e = messages[index];
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
                    );
                  }
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
                          hintText: 'Сообщение...',
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
                if (message.isNotEmpty)
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

  void handleNewMessages(List<Message> messages) {
    final currentUserID = context.read<UserCubit>().getUser()!.id;
    final sender = messages.last.senderName;

    final lastM = messages.last;

    DateTime messageDateTime = DateTime.fromMillisecondsSinceEpoch(lastM.date);

    if (messageDateTime.isAfter(lastReceivedMessageDate) || messageDateTime.isAtSameMomentAs(lastReceivedMessageDate)) {
      lastReceivedMessageDate = messageDateTime;

      if (currentUserID != lastM.senderId) {
        if (!sentMessagesDate.contains(lastM.date)) {
          ChatNotificationController.sendChatNotification(
            sender: sender,
            message: lastM.message,
          );
          sentMessagesDate.add(lastM.date);
          _saveSentMessages();
          print(sentMessagesDate);
        }
      }
    }
  }
}
