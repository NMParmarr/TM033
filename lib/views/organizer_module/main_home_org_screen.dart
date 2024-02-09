import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/text.dart';
import 'package:eventflow/viewmodels/providers/home_provider.dart';
import 'package:eventflow/views/organizer_module/participants_org_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'home_org_screen.dart';
import 'org_profile_screen.dart';

class MainHomeOrgScreen extends StatefulWidget {
  const MainHomeOrgScreen({super.key});

  @override
  State<MainHomeOrgScreen> createState() => _MainHomeOrgScreenState();
}

class _MainHomeOrgScreenState extends State<MainHomeOrgScreen> {
  List<Widget> screens = <Widget>[
    HomeOrgScreen(),
    ParticipantsOrgScreen(),
    OrgProfileScreen(),
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
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Txt(
              "Event Flow",
              textColor: AppColor.theme,
              fontweight: FontWeight.w600,
            ),
          ),
          body: screens[provider.currentScreenIndex],
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: provider.currentScreenIndex,
              onTap: (index) => provider.setCurrentScreenIndex(index: index),
              selectedItemColor: AppColor.theme,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.event_note), label: "Events"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.group), label: "Participants"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: "Settings"),
              ]),
        ),
      );
    });
  }
}
