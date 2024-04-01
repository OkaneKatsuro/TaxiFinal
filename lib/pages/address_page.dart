import 'dart:convert';

import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/widgets/address/address_container.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../res/styles.dart';
import '../widgets/buttons/button2.dart';

import 'address_add_page.dart';

class AddressPage extends StatefulWidget {
  AddressPage({
    super.key,
  });

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  var comment = TextEditingController();

  @override
  void initState() {
    comment = TextEditingController(
        text: context.read<RouteFromToCubit>().get().comment ?? '');
    super.initState();
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
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios, color: black),
                  ),
                  Expanded(child: SizedBox()),
                  Text(
                    'Мои адреса',
                    style: h17w500Black,
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            SizedBox(height: 15),
            MyDivider(),
            SizedBox(height: 20),

            Container(
              height: MediaQuery.of(context).size.height - 210,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    context.read<UserCubit>().getUser()?.addressList != null
                        ? Column(
                            children: [
                              ...context
                                  .watch<UserCubit>()
                                  .getUser()!
                                  .addressList!
                                  .map((e) => AddressContainer(
                                        el: e,
                                        change: () => setState(() {}),
                                      ))
                                  .toList()
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),

            Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () {
                  Get.off(AddressAddPage());
                },
                child: Button2(title: 'Добавить адрес'),
              ),
            ),
            //SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
