import 'package:flutter/material.dart';

import 'package:demo2_app/ui/constants/main_page_enum.dart';

final Map<MainPageEnum, IconData> _tabIcon = {
  MainPageEnum.HOME: Icons.home,
  MainPageEnum.NETWORKS: Icons.group,
  MainPageEnum.PROFILE: Icons.person
};

final Map<MainPageEnum, String> _tabTitle = {
  MainPageEnum.HOME: "Home",
  MainPageEnum.NETWORKS: "Networks",
  MainPageEnum.PROFILE: "Profile"
};

class MainBottomNavigation extends StatelessWidget {
  final MainPageEnum _currentTab;
  final ValueChanged<MainPageEnum> _onSelectTab;

  MainBottomNavigation(this._currentTab, this._onSelectTab);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: MainPageEnum.values.indexOf(_currentTab),
      items: [
        _buildNavBarItem(MainPageEnum.HOME),
        _buildNavBarItem(MainPageEnum.NETWORKS),
        _buildNavBarItem(MainPageEnum.PROFILE)
      ],
      onTap: (index) => _onSelectTab(MainPageEnum.values[index])   
    );
  }

  BottomNavigationBarItem _buildNavBarItem(MainPageEnum tabItem) {
    return BottomNavigationBarItem(
      icon: Icon(
        _tabIcon[tabItem]
      ),
      title: Text(
        _tabTitle[tabItem]
      )
    );
  }
}