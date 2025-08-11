import 'package:al_ummah_institute/screens/show_request.dart';
import 'package:al_ummah_institute/screens/show_result_screen.dart';
import 'package:al_ummah_institute/screens/student_dash_board.dart';
import 'package:al_ummah_institute/widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/notifications.dart';


class MainNav extends StatelessWidget {
  MainNav({Key? key}) : super(key: key);

  final RxInt selectedIndex = 0.obs;

  final List<Widget> screens = [
    StudentDashBoard(),
    Notifications(),
ShowResultScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: screens[selectedIndex.value],
      bottomNavigationBar: CustomNavBar(
        selectedIndex: selectedIndex.value,
        onItemTapped: (int index) {
          selectedIndex.value = index;
        },
      ),
    ));
  }
}
