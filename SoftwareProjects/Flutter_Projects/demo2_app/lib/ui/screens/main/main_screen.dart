import 'package:flutter/material.dart';

import 'package:demo2_app/ui/constants/main_page_enum.dart';
import 'package:demo2_app/ui/constants/routes.dart';
import 'package:demo2_app/ui/widgets/bottom_navigation/main_bottom_navigation.dart';

final Map<MainPageEnum, GlobalKey<NavigatorState>> _navigatorKeys = {
  MainPageEnum.HOME: GlobalKey<NavigatorState>(),
  MainPageEnum.NETWORKS: GlobalKey<NavigatorState>(),
  MainPageEnum.PROFILE: GlobalKey<NavigatorState>()
};

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  MainPageEnum _currentTab = MainPageEnum.HOME;

  NavigatorState get currentNavigation => _navigatorKeys[this._currentTab]?.currentState;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = !await _navigatorKeys[_currentTab].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentTab != MainPageEnum.HOME) {
            _selectTab(MainPageEnum.HOME);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _buildOffstateNavigator(MainPageEnum.HOME),
            _buildOffstateNavigator(MainPageEnum.NETWORKS),
            _buildOffstateNavigator(MainPageEnum.PROFILE),
          ],
        ),
        bottomNavigationBar: MainBottomNavigation(_currentTab, _selectTab),
      )
    );
  }

  Widget _buildOffstateNavigator(MainPageEnum tabItem) {
    String rootPage = MainRouteNames.HOME;

    switch (tabItem) {
      case MainPageEnum.NETWORKS:
        rootPage = MainRouteNames.NETWORKS;
        break;
      case MainPageEnum.PROFILE:
        rootPage = MainRouteNames.PROFILE;
        break;
      default:
        rootPage = MainRouteNames.HOME;
    }

    return Offstage(
      offstage: _currentTab != tabItem,
      child: MainNavigator(
        
      ),
    );
  }

  void _selectTab(MainPageEnum tabItem) {
    if (tabItem == _currentTab) {
      currentNavigation.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = tabItem;
      });
    }
  }
}