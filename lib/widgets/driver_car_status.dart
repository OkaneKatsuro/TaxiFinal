import 'package:cars/models/car_order.dart';
import 'package:cars/res/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/route_from_to/route_from_to.dart';

class DriverCarStatus extends StatelessWidget {
  const DriverCarStatus({super.key});

  @override
  Widget build(BuildContext context) {
    print('status= ${context.read<RouteFromToCubit>().get().status}');
    return Column(
      children: [
        SizedBox(height: 10),
        Text(
          context.watch<RouteFromToCubit>().get().status ==
                  CarOrderStatus.waiting
              ? 'Подтверждение заказа'
              : context.watch<RouteFromToCubit>().get().status ==
                      CarOrderStatus.active
                  ? 'Идет выполнение Заказа'
                  : '',
          style: h17w500Black.copyWith(color: Color.fromARGB(255, 56, 53, 53)),
        ),
        Text(
          'Время: с ${DateFormat('hh:mm, MMM dd').format(context.watch<RouteFromToCubit>().get().startDate!)} до ${DateFormat('hh:mm, MMM dd').format(context.watch<RouteFromToCubit>().get().endDate!)} (${context.watch<RouteFromToCubit>().get().passName})',
          //'',
          style: h14w500Black,
        ),
      ],
    );
  }
}
