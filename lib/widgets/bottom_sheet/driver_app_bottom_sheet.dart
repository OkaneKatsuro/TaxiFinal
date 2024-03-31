import 'package:cars/res/styles.dart';
import 'package:cars/widgets/bottom_sheet/forms/driver_order_form.dart';
import 'package:flutter/material.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

class DriverAppBottomSheet extends StatefulWidget {
  const DriverAppBottomSheet({super.key});

  @override
  State<DriverAppBottomSheet> createState() => _DriverAppBottomSheetState();
}

class _DriverAppBottomSheetState extends State<DriverAppBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SolidBottomSheet(
      showOnAppear: true,
      draggableBody: true,
      toggleVisibilityOnTap: true,
      minHeight: 10,
      maxHeight: 372,
      headerBar: Container(
        color: Colors.white,
        child: Column(
          children: [
            Positioned(
              child: Container(
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: black,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              height: 20,
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        height: 240,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            child: DriverOrderForm(),
          ),
        ),
      ),
    );
  }
}
