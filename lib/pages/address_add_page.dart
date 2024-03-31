import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/models/place.dart';
import 'package:cars/pages/address_search_page.dart';
import 'package:cars/widgets/address/address_container.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../res/styles.dart';
import '../widgets/buttons/button2.dart';
import '../widgets/planing/planing_container.dart';
import 'address_page.dart';

class AddressAddPage extends StatefulWidget {
  AddressAddPage({
    super.key,
    this.address,
  });

  Map<String, Place>? address;
  @override
  State<AddressAddPage> createState() => _AddressAddPageState();
}

class _AddressAddPageState extends State<AddressAddPage> {
  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      setState(() {
        name.text = widget.address!.keys.first;
        addressController.text = widget.address!.values.first.name +
            ', \n' +
            widget.address!.values.first.description!;
        address = widget.address!.values.first;
      });
    }
  }

  final name = TextEditingController();
  final addressController = TextEditingController();
  final focus = FocusNode();
  Place? address;
  final _formKey = GlobalKey<FormState>();
  bool nameRes = true;

  @override
  Widget build(BuildContext context) {
    print('->${address?.name}');
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
                    onTap: () => Get.off(() => AddressPage()),
                    child: Icon(Icons.arrow_back_ios, color: black),
                  ),
                  Expanded(child: SizedBox()),
                  Text(
                    address == null ? 'Новый адрес' : 'Изменить адрес',
                    style: h17w500Black,
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            SizedBox(height: 15),
            MyDivider(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (nameRes == false
                            // ||
                            //     (widget.address != null &&
                            //         widget.address!.keys.first != value)
                            ) {
                          return 'Данное названиее уже используется';
                        }
                        if (value == '') {
                          return 'Название не может быть пустым';
                        }
                        return null;
                      },
                      controller: name,
                      decoration: InputDecoration(
                          labelText: 'Название', labelStyle: h14w400Black),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () => Get.to(AddressSearchPage(
                          setAddress: (val) {
                            setState(() {
                              address = val;
                              addressController.text = address!.name;
                            });
                          },
                          isFrom: false)),
                      child: TextFormField(
                        validator: (value) {
                          if (value == '') {
                            return 'Введите адрес';
                          }
                          return null;
                        },
                        focusNode: focus,
                        onTap: () {
                          focus.nextFocus();
                          Get.to(AddressSearchPage(
                              setAddress: (val) {
                                setState(
                                  () {
                                    address = val;

                                    addressController.text = address!.name +
                                        ', \n' +
                                        (address!.description!);
                                  },
                                );
                              },
                              isFrom: false));
                        },
                        controller: addressController,
                        maxLines: 2,
                        style: h13w400Black,
                        decoration: InputDecoration(
                            labelText: 'Адрес', labelStyle: h14w400Black),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () {
                  if (widget.address == null &&
                      address != null &&
                      name.text != '') {
                    print('add');
                    nameRes = context
                        .read<UserCubit>()
                        .addAddress(name: name.text, place: address!);
                  } else if (address != null && name.text != '') {
                    print('update');
                    nameRes = context.read<UserCubit>().updateAddress(
                        oldAddress: widget.address!,
                        name: name.text,
                        place: address!);
                  }
                  if (_formKey.currentState!.validate())
                    Get.off(() => AddressPage());
                },
                child: Button2(title: 'Сохранить'),
              ),
            ),
            //SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
