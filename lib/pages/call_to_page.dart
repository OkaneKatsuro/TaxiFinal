import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/models/role.dart';
import 'package:cars/pages/one_chat_page.dart';
import 'package:cars/res/firebase_utils.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/call_to/call_to_fake_container.dart';
import 'package:cars/widgets/chat/chat_select_fake.dart';
import 'package:cars/widgets/chat/one_chat_fake.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../bloc/user/user_cubit.dart';
import '../res/styles.dart';

class CallToPass extends StatefulWidget {
  CallToPass({
    super.key,
  });

  @override
  State<CallToPass> createState() => _CallToPassState();
}

class _CallToPassState extends State<CallToPass> {
  var comment = TextEditingController();

  @override
  void initState() {
    comment = TextEditingController(
        text: context.read<RouteFromToCubit>().get().comment ?? '');
    () async {
      var tmp = await getCallMap(context);
      setState(() {
        map = tmp;
      });
    }();
    super.initState();
  }

  Map<String, String> map = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              //color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  Expanded(child: SizedBox()),
                  Text(
                    'Позвонить ${context.read<UserCubit>().getUser()!.role == Role.driver ? 'пассажиру' : 'водителю'}',
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
                children: [
                  ...map.entries.map(
                    (e) => Container(
                      alignment: Alignment.topCenter,
                      color: Colors.white,
                      child: InkWell(
                        onTap: () => launchUrlString("tel:${e.value}"),
                        child: CallToFakeContainer(
                          name: e.key,
                          phone: e.value,
                        ),
                      ),
                    ),
                  )
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
