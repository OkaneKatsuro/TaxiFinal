import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/pages/address_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/place.dart';
import '../../pages/address_add_page.dart';
import '../../res/styles.dart';

class AddressContainer extends StatelessWidget {
  AddressContainer({
    super.key,
    required this.el,
    this.change = null,
  });

  Map<String, Place> el;
  Function? change;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 196, 195, 195).withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.only(top: 15, left: 10, right: 15, bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(el.keys.first, style: h15w500Black),
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: 290,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                el.values.first.name,
                                style: h13w400Black,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                el.values.first.description!,
                                style: h12w400Black.copyWith(color: grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              right: 10,
              bottom: 8,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.off(AddressAddPage(
                      address: el,
                    )),
                    child: Icon(
                      Icons.edit,
                      color: black,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Удаление адреса'),
                          content: const Text(
                              'Вы уверены, что хотите удалить адрес?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Отмена'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Удалить'),
                            ),
                          ],
                        ),
                      );

                      if (result == null || !result) {
                        return;
                      } else {
                        context.read<UserCubit>().deleteAddress(address: el);
                        if (change != null) change!();
                      }
                    },
                    child: Icon(
                      Icons.delete,
                      color: black,
                      size: 20,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
