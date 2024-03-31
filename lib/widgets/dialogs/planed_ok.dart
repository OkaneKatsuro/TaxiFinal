import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/car_order_bloc/car_order_bloc.dart';
import '../../res/styles.dart';

void planedOk(BuildContext context, Function dismis) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => SafeArea(
      child: Dismissible(
        key: const Key('key'),
        direction: DismissDirection.down,
        onDismissed: (_) => dismis(),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          height: MediaQuery.of(context).viewInsets.bottom > 30
              ? MediaQuery.of(context).size.height - 20
              : 400,
          padding: const EdgeInsets.only(top: 20.0),
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).viewInsets.bottom > 30 ? 10 : 300,
          ),
          child: Scaffold(
            body: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: Column(children: [
                        SizedBox(height: 60),
                        const Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.green,
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text('Поездка успешно забронирована',
                            style: h17w500Black),
                        SizedBox(height: 10),
                        Text(
                            '${DateFormat('hh:mm, MMM yy').format(context.read<CarOrderBloc>().currentOrder.startDate!)}',
                            style: h14w500Black),
                        SizedBox(height: 5),
                        Container(
                          width: 300,
                          alignment: Alignment.center,
                          child: Text(
                            '${context.read<CarOrderBloc>().currentOrder.from?.name} - ${context.read<CarOrderBloc>().currentOrder.from?.name}',
                            style: h12w400BlackWithOpacity,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                    ),
                  )),
            ),
          ),
        ),
      ),
    ),
  );
}
