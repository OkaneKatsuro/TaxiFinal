import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/pages/pass_home_page.dart';

import 'package:cars/widgets/buttons/button2.dart';

import 'package:cars/widgets/other/my_divider.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../res/styles.dart';
import '../../change_route/change_route_item.dart';

class ChangeRouteForm extends StatefulWidget {
  ChangeRouteForm({
    super.key,
  });

  @override
  State<ChangeRouteForm> createState() => _ChangeRouteFormState();
}

class _ChangeRouteFormState extends State<ChangeRouteForm> {
  var comment = TextEditingController();

  @override
  void initState() {
    contents = List.generate(1, (index) {
      return DragAndDropList(
        children: [
          DragAndDropItem(
            child: ChangeRouteItem(
              place: context.read<RouteFromToCubit>().get().from!,
              remove: () {},
              showRemove: false,
            ),
          ),
          ...context
              .read<RouteFromToCubit>()
              .get()
              .route!
              .map(
                (e) => DragAndDropItem(
                  child: ChangeRouteItem(
                    place: e,
                    remove: () {},
                    showRemove: false,
                  ),
                ),
              )
              .toList()
        ],
      );
    });

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
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = contents.removeAt(oldListIndex);
      contents.insert(newListIndex, movedList);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(contents.first.children.length);
    return SingleChildScrollView(
      child: Container(
        height: 320,
        width: double.infinity,
        alignment: Alignment.topCenter,
        child: DragAndDropLists(
          children: contents,
          onItemReorder: _onItemReorder,
          onListReorder: _onListReorder,
        ),
      ),
    );
  }
}
