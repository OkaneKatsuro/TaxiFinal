import 'package:cars/res/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../bloc/car_order_bloc/car_order_bloc.dart';
import '../../bloc/live_search_bloc/live_search_bloc.dart';
import '../../pages/pass_home_page.dart';
import '../buttons/button2.dart';
import '../buttons/button3.dart';
import '../map_container.dart';

void selectMapDialog(BuildContext context, bool isFrom, bool isChange) {
  showCupertinoModalPopup<void>(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        print('object');
        context.watch<LiveSearchBloc>().state.when(
              loaded: (res) {
                print('Loaded');
              },
              loading: () {},
              error: () {},
              noData: () {},
            );
        return Scaffold(
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              height: MediaQuery.of(context).size.height - 50,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: MapContainer(),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            context.read<LiveSearchBloc>().state
                                    is LiveSearchStateLoaded
                                ? (context.read<LiveSearchBloc>().state
                                        as LiveSearchStateLoaded)
                                    .searchResult[0]
                                    .name
                                : '',
                            style: h13w500Black,
                          ),
                          SizedBox(height: 2),
                          Text(
                            context.read<LiveSearchBloc>().state
                                    is LiveSearchStateLoaded
                                ? (context.read<LiveSearchBloc>().state
                                        as LiveSearchStateLoaded)
                                    .searchResult[0]
                                    .description!
                                : '',
                            style: h12w400BlackWithOpacity,
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: InkWell(
                              onTap: () {
                                var point = (context
                                        .read<LiveSearchBloc>()
                                        .state as LiveSearchStateLoaded)
                                    .searchResult[0];

                                if (isFrom) {
                                  context
                                      .read<CarOrderBloc>()
                                      .currentOrder
                                      .from = point;
                                } else if (isChange) {
                                  context
                                      .read<CarOrderBloc>()
                                      .currentOrder
                                      .route = [point];
                                } else {
                                  if (context
                                          .read<CarOrderBloc>()
                                          .currentOrder
                                          .route ==
                                      null) {
                                    context
                                        .read<CarOrderBloc>()
                                        .currentOrder
                                        .route = [point];
                                  } else {
                                    context
                                        .read<CarOrderBloc>()
                                        .currentOrder
                                        .route!
                                        .add(point);
                                  }
                                }

                                Get.offAll(() => PassHomePage());
                              },
                              child: Button2(title: 'Готово'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 180,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40)),
                          alignment: Alignment.center,
                          height: 42,
                          width: 42,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
