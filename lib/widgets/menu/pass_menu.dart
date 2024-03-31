import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/pages/address_page.dart';
import 'package:cars/pages/call_to_page.dart';
import 'package:cars/pages/car_settings_page.dart';
import 'package:cars/pages/chats_page.dart';
import 'package:cars/pages/history_page.dart';
import 'package:cars/pages/loading_page.dart';
import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/pages/plan_page.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../bloc/app_bottom_form/app_bottom_form.dart';

class PassMenu extends StatelessWidget {
  const PassMenu({super.key});

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
                Text('Меню пассажира', style: h15w500Black),
              ],
            ),
            SizedBox(height: 10),
            MyDivider(),
            SizedBox(height: 20),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Get.to(HistoryPage());
              },
              leading: const Icon(Icons.history),
              title: Text('История поездок', style: h14w400Black),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Get.to(AddressPage());
              },
              leading: const Icon(Icons.home_outlined),
              title: Text('Мои адреса', style: h14w400Black),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Get.to(PlanPage());
              },
              leading: const Icon(Icons.calendar_month_rounded),
              title: Text('Запланированные поездки', style: h14w400Black),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Get.to(CarSettingsPage());
              },
              leading: const Icon(Icons.settings_outlined),
              title: Text('Состояние машины', style: h14w400Black),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Get.to(() => ChatsPage());
              },
              child: ListTile(
                leading: const Icon(Icons.chat_outlined),
                title: Text('Чаты с водителем', style: h14w400Black),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Get.to(CallToPass());
              },
              leading: const Icon(Icons.call_outlined),
              title: Text('Позвонить водителю', style: h14w400Black),
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
