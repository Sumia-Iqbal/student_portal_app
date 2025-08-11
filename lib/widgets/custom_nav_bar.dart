import 'package:al_ummah_institute/helpers/colors.dart';
import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<IconData> icons = [
      Icons.home,
      Icons.school,
       Icons.grid_view,
      Icons.person,
    ];

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bottomNavColor,
        borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
        boxShadow: [

        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          bool isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onItemTapped(index),
            child:  Icon(
                icons[index],
                color: isSelected ? Colors.white :Colors.white24,
              size: 34,
            ),


          );
        }),
      ),
    );
  }
}
