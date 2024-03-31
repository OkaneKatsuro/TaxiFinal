import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/models/message.dart';
import 'package:cars/models/role.dart';
import 'package:cars/pages/chats_page.dart';
import 'package:cars/res/firebase_utils.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/chat/chat_select_fake.dart';
import 'package:cars/widgets/chat/one_chat_fake.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../res/awesom_utils.dart';
import '../res/styles.dart';

class OneChatPage extends StatefulWidget {
  OneChatPage({
    super.key,
    required this.passId,
    required this.driverId,
  });
  String passId;
  String driverId;
  @override
  State<OneChatPage> createState() => _OneChatPageState();
}

class _OneChatPageState extends State<OneChatPage> {
  var comment = TextEditingController();


  @override
  void initState() {
    comment = TextEditingController(
        text: context.read<RouteFromToCubit>().get().comment ?? '');

    super.initState();

    s = FirebaseFirestore.instance
        .collection('chats')
        .doc('${widget.passId}-${widget.driverId}')
        .collection('messages')
        .snapshots()
        .listen((querySnapshot) async {
      print("UPPPDATE");
      var listTmp = querySnapshot.docs.toList();
      if (listTmp.length > 20) {
        listTmp = querySnapshot.docs
            .toList()
            .sublist(querySnapshot.docs.toList().length - 20);
      }

      listTmp.forEach(
            (element) {
          list.add(Message.fromJson(element.data().values.first));
        },
      );
      setState(() {});
      print(list);
      Future.delayed(Duration(milliseconds: 500), () {
        controller.jumpTo(controller.position.maxScrollExtent);
      });

      // Вызов контроллера уведомлений при получении нового сообщения
      if (listTmp.isNotEmpty) {
        Message latestMessage = Message.fromJson(listTmp.last.data().values.first);
        if (context.read<UserCubit>().get()!.role == Role.pass) {
          ChatNotificationController.sendChatNotification(
            sender: 'Driver', // Здесь нужно указать отправителя сообщения
            message: latestMessage.message,
          );
        } else {
          ChatNotificationController.sendChatNotification(
            sender: 'Passenger', // Здесь нужно указать отправителя сообщения
            message: latestMessage.message,
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
  var s;

  @override
  void dispose() {
    s = null;
    super.dispose();
  }

  var controller = ScrollController();
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
                    'Чат с ${context.read<UserCubit>().get()!.role == Role.pass ? 'водителем' : 'пассажиром'}',
                    style: h17w500Black,
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            SizedBox(height: 15),
            MyDivider(),
            SizedBox(height: 10),

            Container(
              height: WidgetsBinding.instance.window.viewInsets.bottom > 20.0
                  ? MediaQuery.of(context).size.height -
                      MediaQuery.of(context).viewInsets.bottom -
                      260
                  : MediaQuery.of(context).size.height - 200,
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  children: [
                    ...list.map(
                      (e) => Column(
                        crossAxisAlignment:
                            context.read<UserCubit>().get()!.id == e.senderId
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            alignment: context.read<UserCubit>().get()!.id ==
                                    e.senderId
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Text(
                              DateTime(
                                          DateTime.fromMillisecondsSinceEpoch(
                                                  e.date)
                                              .year,
                                          DateTime.fromMillisecondsSinceEpoch(
                                                  e.date)
                                              .month,
                                          DateTime.fromMillisecondsSinceEpoch(
                                                  e.date)
                                              .day) ==
                                      DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day)
                                  ? DateFormat('hh:mm').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          e.date))
                                  : DateFormat('hh:mm, dd MMM').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          e.date)),
                              style: h12w400BlackWithOpacity,
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 150),
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 5,
                                  bottom: 20,
                                  left: context.read<UserCubit>().get()!.id ==
                                          e.senderId
                                      ? 50
                                      : 10,
                                  right: context.read<UserCubit>().get()!.id ==
                                          e.senderId
                                      ? 10
                                      : 50),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(
                                      context.read<UserCubit>().get()!.id ==
                                              e.senderId
                                          ? 25
                                          : 0),
                                  bottomRight: Radius.circular(
                                      context.read<UserCubit>().get()!.id ==
                                              e.senderId
                                          ? 0
                                          : 25),
                                ),
                                color: context.read<UserCubit>().get()!.id ==
                                        e.senderId
                                    ? blue
                                    : whiteGrey2,
                              ),
                              child: Text(
                                e.message,
                                style: h13w500Black.copyWith(
                                    color:
                                        context.read<UserCubit>().get()!.id ==
                                                e.senderId
                                            ? Colors.white
                                            : null),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: 5),
                Container(
                  width: message != ''
                      ? MediaQuery.of(context).size.width - 70
                      : MediaQuery.of(context).size.width - 10,
                  child: Scrollbar(
                    child: TextField(
                      controller: textcontroller,
                      onChanged: (value) => setState(() {
                        message = value;
                      }),
                      scrollPadding: EdgeInsets.only(right: 4),
                      scrollController: scrollController,
                      maxLines: 4,
                      minLines:
                          WidgetsBinding.instance.window.viewInsets.bottom > 0.0
                              ? 4
                              : 1,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(20)),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(20)),
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
                            senderId: context.read<UserCubit>().get()!.id,
                            senderName: context.read<UserCubit>().get()!.fname +
                                ' ' +
                                context.read<UserCubit>().get()!.lname,
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
            // Container(
            //   height: 800,
            //   child: OneChatFake(),
            // ),
          ],
        ),
      ),
    );
  }
}
