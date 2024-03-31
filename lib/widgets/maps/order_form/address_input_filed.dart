import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../res/styles.dart';

class AddressInputField extends StatelessWidget {
  AddressInputField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.change,
    required this.isActive,
    this.showFrom = false,
    this.showWhere = false,
    this.focus = null,
    this.controller = null,
  });

  String hintText;
  Widget icon;
  bool isActive;
  Function change;
  bool showWhere;
  bool showFrom;
  FocusNode? focus;
  TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    print(showFrom);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 54,
          color: Colors.white,
        ),
        SizedBox(
          height: 42,
          child: TextFormField(
            controller: controller,
            focusNode: focus,
            enabled: isActive,
            onChanged: (val) => change(val),
            decoration: InputDecoration(
              fillColor: whiteGrey,
              filled: true,
              contentPadding: EdgeInsets.all(4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: icon,
              hintStyle: h13w400Black,
              hintText: hintText,
            ),
          ),
        ),
        if (showFrom || showWhere)
          Positioned(
            top: 4,
            left: 20,
            child: Text(showFrom ? 'Откуда' : 'Куда', style: h11w400Blue),
          ),
      ],
    );
  }
}
