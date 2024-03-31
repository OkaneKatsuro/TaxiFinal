import 'package:cars/models/car_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'forms/pass_plan_form.dart';

class PassBottomSheetBody extends StatelessWidget {
  PassBottomSheetBody({super.key, required this.order});
  CarOrder order;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 362,
      width: double.infinity,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: PassPlanForm(order: order),
        ),
      ),
    );
  }
}
