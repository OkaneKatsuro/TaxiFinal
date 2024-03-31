import 'package:cars/pages/call_to_page.dart';
import 'package:cars/pages/car_settings_page.dart';
import 'package:cars/pages/chats_page.dart';
import 'package:cars/pages/history_page.dart';
import 'package:cars/pages/plan_page.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../bloc/user/user_cubit.dart';
import '../../pages/loading_page.dart';

class DriverMenu extends StatelessWidget {
  const DriverMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width - 50,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios)),
                Text('Меню водителя', style: h15w500Black),
              ],
            ),
            SizedBox(height: 10),
            MyDivider(),
            SizedBox(height: 20),
            ListTile(
              onTap: () => Get.to(HistoryPage()),
              leading: const Icon(Icons.history),
              title: Text('История поездок', style: h14w400Black),
            ),
            ListTile(
              onTap: () => Get.to(PlanPage()),
              leading: const Icon(Icons.calendar_month_rounded),
              title: Text('Запланированные поездки', style: h14w400Black),
            ),
            ListTile(
              onTap: () => Get.to(CarSettingsPage()),
              leading: const Icon(Icons.settings_outlined),
              title: Text('Состояние машины', style: h14w400Black),
            ),
            InkWell(
              onTap: () => Get.to(ChatsPage()),
              child: ListTile(
                leading: const Icon(Icons.chat_outlined),
                title: Text('Чаты с пассажирами', style: h14w400Black),
              ),
            ),
            ListTile(
              onTap: () => Get.to(CallToPass()),
              leading: const Icon(Icons.call_outlined),
              title: Text('Позвонить пассажиру', style: h14w400Black),
            ),
            ListTile(
              onTap: () {
                FirebaseAuth.instance.signOut();
                context.read<UserCubit>().set(null);
                Get.offAll(const LoadingPage());
              },
              leading: const Icon(Icons.exit_to_app),
              title: Text('Выйти из аккаунта', style: h14w400Black),
            ),
          ],
        ),
      ),
    );
  }
}
