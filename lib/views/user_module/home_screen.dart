import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:eventflow/utils/widgets/custom_text_field.dart';
import 'package:eventflow/views/user_module/event_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/datasource/services/firebase_services.dart';
import '../../data/models/event_model.dart';
import '../../data/models/event_type.dart';
import '../../resources/helper/shared_preferences.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/image_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController? _searchCtr;

  @override
  void initState() {
    super.initState();
    _searchCtr = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtr?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String?>(
          future: Shared_Preferences.prefGetString(App.orgId, ""),
          builder: (context, orgId) {
            if (orgId.hasData) {
              return StreamBuilder<List<EventType>>(
                  stream: FireServices.instance
                      .fetchEventTypeByOrg(orgId: orgId.data!),
                  builder: (context, typeSnap) {
                    if (typeSnap.hasData) {
                      return _contentWidget(eventTypes: typeSnap.data!);
                    } else if (orgId.hasError) {
                      print(" --- err event type snap -- ${orgId.error}");
                      return Center(
                          child: Icon(Icons.error, color: AppColor.theme));
                    } else {
                      return Center(child: Image.asset(Images.loadingGif));
                    }
                  });
            } else if (orgId.hasError) {
              print(" --- err org id snap -- ${orgId.error}");
              return Center(child: Icon(Icons.error, color: AppColor.theme));
            } else {
              return Center(child: Image.asset(Images.loadingGif));
            }
          }),
    );
  }

  Widget welcomeScreen() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Images.welcomGif,
            height: 30.h,
          ),
          Txt(
            "Welcome to",
            fontsize: 4.t,
            textColor: AppColor.theme,
            fontweight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          Txt(
            "EventFlow ..!",
            fontsize: 5.t,
            textColor: AppColor.theme,
            fontweight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          VGap(2.h),
          // Txt(
          //   "Start publishing your upcoming events by clicking below button..!",
          //   textAlign: TextAlign.center,
          //   fontsize: 2.t,
          // )
        ],
      ),
    );
  }

  Widget _contentWidget({required List<EventType> eventTypes}) {
    print(" --- length of eventtypes : ${eventTypes.length}");
    return eventTypes.length <= 0
        ? welcomeScreen()
        : DefaultTabController(
            length: eventTypes.length,
            child: Column(children: [
              VGap(1.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: CustomTextField(
                    ctr: _searchCtr!,
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search"),
              ),
              VGap(1.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Container(
                  height: 5.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.2)
                      // color: AppColor.tabbarBg,
                      ),
                  child: TabBar(
                      splashBorderRadius: BorderRadius.circular(10),
                      isScrollable: true,
                      dividerHeight: 0,
                      tabAlignment: TabAlignment.start,
                      dividerColor: Colors.white,
                      labelStyle: GoogleFonts.philosopher(color: Colors.white),
                      indicatorPadding: EdgeInsets.symmetric(
                          horizontal: 1.w, vertical: 0.5.h),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      tabs: List.generate(eventTypes.length,
                          (index) => Tab(text: eventTypes[index].name))),
                ),
              ),
              VGap(1.h),
              Expanded(
                child: TabBarView(
                    children: List.generate(
                        eventTypes.length,
                        (index) => StreamBuilder<List<EventModel>>(
                            stream: FireServices.instance.fetchEventsByTypeId(
                                orgId: eventTypes[index].orgId!,
                                typeId: eventTypes[index].typeId!),
                            builder: (context, eventSnap) {
                              if (eventSnap.hasData) {
                                return EventsList(events: eventSnap.data!);
                              } else if (eventSnap.hasError) {
                                print(
                                    " --- err events snap -- ${eventSnap.error}");
                                return Center(
                                    child: Icon(Icons.error,
                                        color: AppColor.theme));
                              } else {
                                return Center(
                                    child: Image.asset(Images.loadingGif));
                              }
                            }))),
              )
            ]),
          );
  }
}
