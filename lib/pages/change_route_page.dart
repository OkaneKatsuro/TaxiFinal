import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/models/place.dart';
import 'package:cars/pages/one_chat_page.dart';
import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/pages/search_page.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/buttons/button2.dart';
import 'package:cars/widgets/chat/chat_select_fake.dart';
import 'package:cars/widgets/chat/one_chat_fake.dart';
import 'package:cars/widgets/maps/search_form/search_row.dart';
import 'package:cars/widgets/other/blue_point.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../res/styles.dart';
import '../widgets/change_route/change_route_item.dart';
import '../widgets/dialogs/select_route_dialog.dart';

class ChangeRoutePage extends StatefulWidget {
  ChangeRoutePage({
    super.key,
  });

  @override
  State<ChangeRoutePage> createState() => _ChangeRoutePageState();
}

class _ChangeRoutePageState extends State<ChangeRoutePage> {
  var comment = TextEditingController();

  void gen() {
    contents = List.generate(1, (index) {
      return DragAndDropList(
        children: [
          ...context
              .read<CarOrderBloc>()
              .currentOrder
              .route!
              .map(
                (e) => DragAndDropItem(
                  child: ChangeRouteItem(
                    place: e,
                    remove: () {
                      setState(() {
                        context
                            .read<CarOrderBloc>()
                            .currentOrder
                            .route!
                            .remove(e);
                        gen();
                      });
                    },
                  ),
                ),
              )
              .toList()
        ],
      );
    });
  }

  @override
  void initState() {
    gen();
    super.initState();
  }

  List<DragAndDropList> contents = [];

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      //--

      var movedItem = contents[oldListIndex].children.removeAt(oldItemIndex);
      contents[newListIndex].children.insert(newItemIndex, movedItem);
    });

    var tmp = context.read<CarOrderBloc>().currentOrder.route!;
    var item = tmp[oldItemIndex];
    tmp.removeAt(oldItemIndex);
    tmp.insert(newItemIndex, item);
    context.read<CarOrderBloc>().currentOrder.route = tmp;
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = contents.removeAt(oldListIndex);
      contents.insert(newListIndex, movedList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Row(
                children: [
                  Expanded(child: SizedBox()),
                  Text(
                    'Изменить маршрут',
                    style: h17w500Black,
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            Container(
              height: 15,
              color: Colors.white,
            ),
            MyDivider(),
            SizedBox(height: 20),
            Container(
              width: 400,
              height: 245,
              child: DragAndDropLists(
                children: contents,
                onItemReorder: _onItemReorder,
                onListReorder: _onListReorder,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () => selectRouteDialog(
                    SearchPage(
                      setAddress: () {
                        setState(() {});
                      },
                      isFrom: false,
                      isChange: false,
                    ),
                    () {},
                    context),
                child: Button2(title: 'Добавить остановку'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
