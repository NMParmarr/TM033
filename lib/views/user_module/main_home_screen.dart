import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/text.dart';
import 'package:eventflow/viewmodels/providers/home_provider.dart';
import 'package:eventflow/views/user_module/home_screen.dart';
import 'package:eventflow/views/user_module/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/datasource/services/connection/network_checker_widget.dart';
import 'joined_events_screen.dart';

class MainHomeScren extends StatefulWidget {
  const MainHomeScren({super.key});

  @override
  State<MainHomeScren> createState() => _MainHomeScrenState();
}

class _MainHomeScrenState extends State<MainHomeScren> {
  List<Widget> screens = <Widget>[
    HomeScreen(),
    JoinedEventsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false)
        .setCurrentScreenIndex(index: 0, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, _) {
      return PopScope(
        canPop: false,
        onPopInvoked: (_) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
        child: NetworkCheckerWidget(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.theme,
              automaticallyImplyLeading: false,
              title: Txt(
                "Event Flow",
                textColor: Colors.white,
                fontweight: FontWeight.w600,
              ),
            ),
            body: screens[provider.currentScreenIndex],
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: provider.currentScreenIndex,
                onTap: (index) => provider.setCurrentScreenIndex(index: index),
                selectedItemColor: AppColor.theme,
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_month_outlined), label: "Joined"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: "Profile"),
                ]),
          ),
        ),
      );
    });
  }
}
