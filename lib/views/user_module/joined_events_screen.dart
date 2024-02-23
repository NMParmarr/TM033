import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/views/user_module/event_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../data/datasource/services/connection/network_checker_widget.dart';
import '../../data/datasource/services/firebase/firebase_services.dart';
import '../../data/models/event_model.dart';
import '../../data/models/user_model.dart';
import '../../resources/helper/shared_preferences.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/constants/image_constants.dart';

class JoinedEventsScreen extends StatefulWidget {
  const JoinedEventsScreen({super.key});

  @override
  State<JoinedEventsScreen> createState() => _JoinedEventsScreenState();
}

class _JoinedEventsScreenState extends State<JoinedEventsScreen> {
  final formattedTodayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return NetworkCheckerWidget(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Column(children: [
            TabBar(
                labelStyle: GoogleFonts.philosopher(),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_month_sharp),
                      HGap(1.w),
                      Text("Upcoming")
                    ],
                  )),
                  Tab(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.watch_later_outlined),
                      HGap(1.w),
                      Text("Past")
                    ],
                  ))
                ]),
            VGap(2.h),
            Expanded(
                child: FutureBuilder<String?>(
                    future: Shared_Preferences.prefGetString(App.id, ""),
                    builder: (context, userId) {
                      if (userId.hasData) {
                        return StreamBuilder<UserModel>(
                            stream: FireServices.instance
                                .fetchSingleUser(id: userId.data!),
                            builder: (context, user) {
                              if (user.hasData) {
                                return TabBarView(
                                  children: [
                                    FutureBuilder<List<EventModel>>(
                                        future: FireServices.instance
                                            .fetchJoinedUpcomingEvents(
                                                userId: user.data!.id!,
                                                todayDate: formattedTodayDate),
                                        builder: (context, upcomingEvents) {
                                          if (upcomingEvents.hasData) {
                                            return EventsList(
                                                events:
                                                    upcomingEvents.data ?? []);
                                          } else if (upcomingEvents.hasError) {
                                            print(
                                                " --- err dfdfsdgh : ${upcomingEvents.error}");
                                            return Center(
                                                child: Icon(Icons.error,
                                                    color: AppColor.theme));
                                          } else {
                                            return Center(
                                                child: Image.asset(
                                                    Images.loadingGif));
                                          }
                                        }),
                                    FutureBuilder<List<EventModel>>(
                                        future: FireServices.instance
                                            .fetchJoinedPastEvents(
                                                userId: user.data!.id!,
                                                todayDate: formattedTodayDate),
                                        builder: (context, pastEvents) {
                                          if (pastEvents.hasData) {
                                            return EventsList(
                                                events: pastEvents.data ?? []);
                                          } else if (pastEvents.hasError) {
                                            print(
                                                " --- err df5adfs : ${pastEvents.error}");
                                            return Center(
                                                child: Icon(Icons.error,
                                                    color: AppColor.theme));
                                          } else {
                                            return Center(
                                                child: Image.asset(
                                                    Images.loadingGif));
                                          }
                                        }),
                                  ],
                                );
                              } else if (userId.hasError) {
                                print(" --- err dfkjlaiejlkf : ${userId.error}");
                                return Center(
                                    child:
                                        Icon(Icons.error, color: AppColor.theme));
                              } else {
                                return Center(
                                    child: Image.asset(Images.loadingGif));
                              }
                            });
                      } else if (userId.hasError) {
                        print(" --- err dfkjlaiejlkf : ${userId.error}");
                        return Center(
                            child: Icon(Icons.error, color: AppColor.theme));
                      } else {
                        return Center(child: Image.asset(Images.loadingGif));
                      }
                    }))
          ]),
        ),
      ),
    );
  }
}
