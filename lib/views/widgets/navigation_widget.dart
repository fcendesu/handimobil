import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'İşler',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Keşif',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.production_quantity_limits_outlined),
          label: 'Malzeme',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: onItemTapped,
    );
  }
}
