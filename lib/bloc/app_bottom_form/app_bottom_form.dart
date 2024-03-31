import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class AppBottomFormCubit extends Cubit<ShowBottomForm> {
  AppBottomFormCubit() : super(ShowBottomForm.orderNow);
  void set(ShowBottomForm val) => emit(val);
  ShowBottomForm get() => state.obs.value;
}

enum ShowBottomForm {
  plan,
  orderNow,
  comment,
}
