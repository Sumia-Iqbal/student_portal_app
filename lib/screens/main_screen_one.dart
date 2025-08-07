import 'package:al_ummah_institute/helpers/colors.dart';
import 'package:al_ummah_institute/screens/posts_screen.dart';
import 'package:al_ummah_institute/screens/teacher_dash_board.dart';
import 'package:al_ummah_institute/screens/teachers_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MainScreenOne extends StatelessWidget {
  const MainScreenOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RxInt selectedIndex = 0.obs;

    List pages = [
      TeacherDashBoard(),
      TeachersList(),
      PostsScreen()


    ];
    return Obx(() {
      return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: drawerContainer,
              unselectedItemColor: drawerContainer.withOpacity(0.6),
              items: [
          BottomNavigationBarItem(icon: Icon(Iconsax.teacher),label:"Students"),
      BottomNavigationBarItem(icon: Icon(Iconsax.people),label:"Teachers"),
      BottomNavigationBarItem(icon: Icon(Iconsax.teacher),label:"Posts")


      ],
      onTap: (value){
      selectedIndex.value = value;
      },
      currentIndex: selectedIndex.value,

      ),


      body: pages[selectedIndex.value]
      );
      });
  }
}
