import 'dart:async';

import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:cars/bloc/live_search_bloc/live_search_bloc.dart';
import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/models/place.dart';
import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/map_container.dart';
import 'package:cars/widgets/maps/map_page.dart';
import 'package:cars/widgets/maps/order_form/address_input_filed.dart';
import 'package:cars/widgets/maps/search_form/search_results.dart';
import 'package:cars/widgets/maps/search_form/search_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../bloc/route_from_to/route_from_to.dart';
import '../res/utils.dart';
import '../widgets/buttons/button2.dart';

class SearchPage extends StatefulWidget {
  SearchPage(
      {super.key,
      required this.setAddress,
      required this.isFrom,
      this.isChange = false});
  Function setAddress;
  bool isFrom;
  bool isChange;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Place> result = [];
  bool isLoading = false;
  Timer? timer;
  bool showOnMap = false;
  FocusNode focus = new FocusNode();
  String place = '';
  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    context.watch<LiveSearchBloc>().state.when(
          loaded: (res) {
            if (!showOnMap) {
              isLoading = false;
              result = res;
            } else {
              try {
                // place = res[0].name;
                // result = res;
                controller.text = '';
                print(res[0].name);
              } catch (e) {
                print(e);
              }
            }
          },
          loading: () {
            if (!showOnMap) {
              isLoading = true;
            }
          },
          error: () {},
          noData: () {
            result = [];
          },
        );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        print('$place - $showOnMap');
                        // try {
                        //   if (widget.isFrom) {
                        //     context.read<CarOrderBloc>().currentOrder.from =
                        //         result[0];
                        //   } else if (showOnMap && !widget.isChange) {
                        //     context
                        //         .read<CarOrderBloc>()
                        //         .currentOrder
                        //         .route!
                        //         .add(result[0]);
                        //   } else if (showOnMap && widget.isChange) {
                        //     context.read<CarOrderBloc>().currentOrder.route = [
                        //       result[0]
                        //     ];
                        //   }
                        // } catch (e) {}
                        if (showOnMap) {
                          Get.to(() => PassHomePage());
                        } else {
                          Get.to(() => PassHomePage());
                        }
                      },
                      child: Icon(Icons.arrow_back_ios),
                    ),
                    InkWell(
                      onTap: () {
                        print('$place - $showOnMap');
                        // try {
                        //   if (widget.isFrom) {
                        //     context.read<CarOrderBloc>().currentOrder.from =
                        //         result[0];
                        //   } else if (showOnMap && !widget.isChange) {
                        //     context
                        //         .read<CarOrderBloc>()
                        //         .currentOrder
                        //         .route!
                        //         .add(result[0]);
                        //   } else if (showOnMap && widget.isChange) {
                        //     context.read<CarOrderBloc>().currentOrder.route = [
                        //       result[0]
                        //     ];
                        //   }
                        // } catch (e) {}
                        if (showOnMap) {
                          Get.to(() => PassHomePage());
                        } else {
                          Get.to(() => PassHomePage());
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        child: Button2(title: 'Готово'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showOnMap = false;
                    });
                    Future.delayed(Duration(milliseconds: 200), () {
                      FocusScope.of(context).requestFocus(focus);
                    });
                  },
                  child: AddressInputField(
                    controller: controller,
                    focus: focus,
                    isActive: !showOnMap,
                    change: (val) {
                      if (val != '') {
                        timer?.cancel();
                        context
                            .read<LiveSearchBloc>()
                            .add(LiveSearchEvent.fetch(text: val));
                        context
                            .read<LiveSearchBloc>()
                            .add(LiveSearchEvent.fetch(text: val));
                      }
                    },
                    hintText: showOnMap ? place : 'Ведите адрес',
                    icon: Container(
                      width: 5,
                      height: 5,
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: blue,
                      ),
                    ),
                  ),
                ),
              ),
              // if (!showOnMap)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        if (!isLoading)
                          Column(
                            children: [
                              if (controller.text == '')
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      showOnMap = true;
                                      place = '';
                                      controller.text = '';
                                    });
                                    ;
                                  },
                                  child: SearchRow(
                                    firstString: 'Указать на карте',
                                    secnodString: '',
                                    icon: Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      child: SvgPicture.asset(
                                          'asstes/telegram.svg'),
                                    ),
                                  ),
                                ),
                              const Divider(),
                              if (controller.text == '')
                                InkWell(
                                  onTap: () {
                                    Future.delayed(const Duration(seconds: 0),
                                        () async {
                                      try {
                                        var point = await getCurrentPoint();
                                        if (widget.isFrom) {
                                          context
                                              .read<CarOrderBloc>()
                                              .currentOrder
                                              .from = point;
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

                                        // Get.back();
                                        Get.to(() => PassHomePage());
                                      } catch (e) {}
                                    });
                                  },
                                  child: SearchRow(
                                    firstString: 'Мое местоположение',
                                    secnodString: '',
                                    icon: Icon(
                                      Icons.gps_fixed_outlined,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              const Divider(),
                              const SizedBox(height: 6),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (controller.text == '')
                Column(
                  children: [
                    ...context
                        .read<UserCubit>()
                        .getUser()!
                        .addressList!
                        .map(
                          (e) => Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (widget.isFrom) {
                                    context
                                        .read<CarOrderBloc>()
                                        .currentOrder
                                        .from = e.values.first;
                                  } else {
                                    if (widget.isChange) {
                                      context
                                          .read<CarOrderBloc>()
                                          .currentOrder
                                          .route = [e.values.first];
                                    } else {
                                      context
                                          .read<CarOrderBloc>()
                                          .currentOrder
                                          .route!
                                          .add(e.values.first);
                                    }
                                  }

                                  Get.off(() => PassHomePage());
                                },
                                child: Container(
                                  height: 41,
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  width: double.infinity,
                                  child: SearchRow(
                                    firstString: e.keys.first +
                                        ' (${e.values.first.name})',
                                    secnodString:
                                        e.values.first.description ?? '',
                                    icon: Container(
                                      width: 7,
                                      height: 7,
                                      alignment: Alignment.center,
                                      color: grey,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        )
                        .toList(),
                  ],
                ),
              isLoading
                  ? const CircularProgressIndicator()
                  : showOnMap
                      ? Container(
                          //  margin: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 265,
                          child: MapContainer(),
                        )
                      : SearchResultsColumn(
                          isChange: widget.isChange,
                          isFrom: widget.isFrom,
                          results: result,
                          setAddress: widget.setAddress),
            ],
          ),
        ),
      ),
    );
  }
}
