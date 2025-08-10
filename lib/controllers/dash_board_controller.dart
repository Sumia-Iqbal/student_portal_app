import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DashboardController extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }
}
