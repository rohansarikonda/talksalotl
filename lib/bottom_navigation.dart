import 'package:flutter/material.dart';
import 'app.dart';
import 'tab_item.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({
    required this.onSelectTab,
    required this.tabs,
  });
  final ValueChanged<int> onSelectTab;
  final List<TabItem> tabs;

// creates the bottom navigation bar containing home and profile buttons
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: tabs
          .map(
            (e) => _buildItem(
              index: e.getIndex(),
              icon: e.icon,
              tabName: e.tabName,
            ),
          )
          .toList(),
      onTap: (index) => onSelectTab(
        index,
      ),
    );
  }


  BottomNavigationBarItem _buildItem(
      {required int index, required IconData icon, required String tabName}) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _tabColor(index: index),
        ),
        label: tabName);
  }

// sets color of bottom navigation bar
  Color _tabColor({required int index}) {
    return AppState.currentTab == index ? Colors.cyan : Colors.grey;
  }
}
