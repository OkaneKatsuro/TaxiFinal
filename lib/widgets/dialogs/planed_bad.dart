import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../res/styles.dart';

void planedBad(BuildContext context, Function dismis, res) {
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
                        Icon(
                          Icons.block,
                          color: Colors.red,
                          size: 80,
                        ),
                        SizedBox(height: 20),
                        Text('Поездка в это время не возможна!',
                            style: h17w500Black),
                        SizedBox(height: 3),
                        Text(
                          'т.к ранее был запланирован другой заказ:',
                          style: h14w400Black.copyWith(color: grey),
                        ),
                        SizedBox(height: 20),
                        Text(
                          '${DateFormat('hh:mm, dd MMM').format(res.startDate!)} - ${DateFormat('hh:mm, dd MMM').format(res.endDate!)} \n${res.passName}',
                          style: h15w500Black,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
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
