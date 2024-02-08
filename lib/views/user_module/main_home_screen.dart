import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/text.dart';
import 'package:eventflow/viewmodels/providers/home_provider.dart';
import 'package:eventflow/views/user_module/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MainHomeScren extends StatefulWidget {
  const MainHomeScren({super.key});

  @override
  State<MainHomeScren> createState() => _MainHomeScrenState();
}

class _MainHomeScrenState extends State<MainHomeScren> {
  List<Widget> screens = <Widget>[
    // Container(child: Center(child: Txt("Home"))),
    HomeScreen(),
    Container(child: Center(child: Txt("Joined"))),
    Container(child: Center(child: Txt("Profile"))),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvide>(builder: (context, provider, _) {
      return PopScope(
        canPop: false,
        onPopInvoked: (_) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Txt("Event Flow", textColor: AppColor.theme),
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
      );
    });
  }
}
