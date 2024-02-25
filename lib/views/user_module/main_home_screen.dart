import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/text.dart';
import 'package:eventflow/viewmodels/providers/home_provider.dart';
import 'package:eventflow/views/user_module/home_screen.dart';
import 'package:eventflow/views/user_module/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:eraser/eraser.dart';
import '../../data/datasource/services/connection/network_checker_widget.dart';
import '../../data/datasource/services/firebase/firebase_messaging.dart';
import '../../utils/common_utils.dart';
import 'joined_events_screen.dart';

class MainHomeScren extends StatefulWidget {
  const MainHomeScren({super.key});

  @override
  State<MainHomeScren> createState() => _MainHomeScrenState();
}

class _MainHomeScrenState extends State<MainHomeScren> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> screens = <Widget>[
    HomeScreen(),
    JoinedEventsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    FireMessaging.instance.listenMessaging(context);
    FireMessaging.instance.setupInteractMessage(context);
    Eraser.clearAllAppNotifications();
    Provider.of<HomeProvider>(context, listen: false).setCurrentScreenIndex(index: 0, listen: false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleState.resumed == state) {
      Eraser.clearAllAppNotifications();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: AppColor.theme,
              automaticallyImplyLeading: false,
              title: Txt(
                "Event Flow",
                textColor: Colors.white,
                fontweight: FontWeight.w600,
              ),
              actions: [
                IconButton(
                    onPressed: ()  async {
                      await Utils.aboutAppDialog(context);
                    },
                    icon: const Icon(
                      Icons.info_outlined,
                      color: Color.fromARGB(255, 190, 190, 190),
                    ))
              ],
            ),
            body: screens[provider.currentScreenIndex],
            bottomNavigationBar:
                BottomNavigationBar(currentIndex: provider.currentScreenIndex, onTap: (index) => provider.setCurrentScreenIndex(index: index), selectedItemColor: AppColor.theme, items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "Joined"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            ]),
          ),
        ),
      );
    });
  }
}
