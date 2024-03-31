import 'dart:async';

import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:cars/bloc/live_search_bloc/live_search_bloc.dart';
import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/models/place.dart';
import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/dialogs/select_map_dialog.dart';
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
  bool isGeoLoading = false;
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
                place = res[0].name;
                result = res;
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
      body: isGeoLoading
          ? Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: Container(
                height: 150,
                width: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Пожалуйстаа подождите',
                      style: h14w500Black,
                    ),
                    Text(
                      'Идет определение вашего местоположения',
                      style: h12w400BlackWithOpacity,
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            )
          : Column(
              children: [
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (controller.text == '')
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        selectMapDialog(context, widget.isFrom,
                                            widget.isChange);
                                        // setState(() {
                                        //   showOnMap = true;
                                        //   place = '';
                                        //   controller.text = '';
                                        // });
                                        // ;
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
                                    InkWell(
                                      onTap: () {
                                        Future.delayed(
                                            const Duration(seconds: 0),
                                            () async {
                                          try {
                                            setState(() {
                                              isGeoLoading = true;
                                            });
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
                                            setState(() {
                                              isGeoLoading = false;
                                            });
                                            // Get.back();
                                            Get.offAll(() => PassHomePage());
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
                          ),
                        if (controller.text == '')
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              children: [
                                ...context
                                    .read<UserCubit>()
                                    .get()!
                                    .addressList!
                                    .map(
                                      (e) => Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (widget.isFrom) {
                                                setState(() {});

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

                                              widget.setAddress();
                                              Get.offAll(() => PassHomePage());
                                            },
                                            child: Container(
                                              height: 41,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 15),
                                              width: double.infinity,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child: SearchRow(
                                                  firstString: e.keys.first +
                                                      ' (${e.values.first.name})',
                                                  secnodString: e.values.first
                                                          .description ??
                                                      '',
                                                  icon: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10.0),
                                                    child: Container(
                                                      width: 7,
                                                      height: 7,
                                                      color: grey,
                                                    ),
                                                  ),
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
                          ),
                        isLoading
                            ? const CircularProgressIndicator()
                            : Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: SearchResultsColumn(
                                      isChange: widget.isChange,
                                      isFrom: widget.isFrom,
                                      results: result,
                                      setAddress: widget.setAddress),
                                ),
                              ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
