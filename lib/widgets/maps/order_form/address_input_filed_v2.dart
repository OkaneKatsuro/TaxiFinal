import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../res/styles.dart';

class AddressInputFieldV2 extends StatefulWidget {
  AddressInputFieldV2({
    super.key,
    required this.hintText,
    required this.icon,
    required this.change,
    required this.isActive,
    this.showFrom = false,
    this.showWhere = false,
    this.focus = null,
    this.validateDate = false,
  });

  String hintText;
  Widget icon;
  bool isActive;
  Function change;
  bool showWhere;
  bool showFrom;
  FocusNode? focus;
  bool validateDate;
  @override
  State<AddressInputFieldV2> createState() => _AddressInputFieldV2State();
}

class _AddressInputFieldV2State extends State<AddressInputFieldV2> {
  bool isRed = false;
  TextStyle hintStyle = h12w400Black;

  @override
  void initState() {
    hintStyle = !widget.hintText.contains('?')
        ? h13w400Black.copyWith(fontWeight: FontWeight.w400)
        : h12w400Black;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            validator: (value) {
              if (widget.hintText.contains('?')) {
                setState(() {
                  isRed = true;
                });
              } else if (widget.validateDate &&
                  !widget.hintText.contains('.') &&
                  context.read<CarOrderBloc>().carStatusStr !=
                      'Машина свободна') {
                setState(() {
                  isRed = true;
                });
              } else if (widget.validateDate) {
                setState(() {
                  isRed = false;
                });
              }

              setState(() {
                hintStyle = isRed
                    ? h13w400Black.copyWith(
                        fontWeight: FontWeight.w400, color: Colors.red)
                    : h13w400Black;
              });

              return null;
            },
            focusNode: widget.focus,
            enabled: widget.isActive,
            onChanged: (val) => widget.change(val),
            decoration: InputDecoration(
              fillColor: whiteGrey,
              contentPadding:
                  const EdgeInsets.only(top: 6, bottom: 8, right: 5),
              prefixIcon: widget.icon,
              hintStyle: hintStyle,
              hintText: widget.hintText,
            ),
          ),
        ),
      ],
    );
  }
}
