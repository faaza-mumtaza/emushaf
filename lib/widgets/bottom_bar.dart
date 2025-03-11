import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:emushaf/utils/constants.dart';

class BottomBar extends StatelessWidget {
  final Function changeIndex;
  final int currentIndex;
  BottomBar({required this.changeIndex, required this.currentIndex});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: this.currentIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      unselectedIconTheme: IconThemeData(
        color: Color.fromRGBO(202, 205, 219, 1),
      ),
      selectedIconTheme: IconThemeData(
        color: Constants.primaryColor,
      ),
      onTap: (index) {
        changeIndex(index);
      },
      items: [
        BottomNavigationBarItem(
          label: "",
          icon: Icon(AntDesign.home),
        ),
        BottomNavigationBarItem(
          label: "",
          icon: Icon(
            Feather.book_open,
          ),
        ),
        BottomNavigationBarItem(
          label: "",
          icon: Icon(
            Feather.grid,
          ),
        ),
        BottomNavigationBarItem(
          label: "",
          icon: Icon(
            AntDesign.search1,
          ),
        ),
        BottomNavigationBarItem(
          label: "",
          icon: Icon(
            Feather.bookmark,
          ),
        ),
        BottomNavigationBarItem(
          label: "",
          icon: Icon(
            Feather.user,
          ),
        ),
      ],
    );
  }
}
