import 'package:eventflow/data/datasource/services/firebase/firebase_services.dart';
import 'package:eventflow/data/models/event_model.dart';
import 'package:eventflow/resources/helper/shared_preferences.dart';
import 'package:eventflow/utils/constants/app_constants.dart';
import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/views/organizer_module/events_org_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/datasource/services/connection/network_checker_widget.dart';

class ParticipantsOrgScreen extends StatefulWidget {
  const ParticipantsOrgScreen({super.key});

  @override
  State<ParticipantsOrgScreen> createState() => _ParticipantsOrgScreenState();
}

class _ParticipantsOrgScreenState extends State<ParticipantsOrgScreen> {
  // final formattedTodayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());

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
            VGap(1.h),
            Expanded(
                child: FutureBuilder<String?>(
                    future: Shared_Preferences.prefGetString(App.id, ""),
                    builder: (context, orgId) {
                      if (orgId.hasData) {
                        return TabBarView(
                          children: [
                            StreamBuilder<List<EventModel>>(
                                stream: FireServices.instance
                                    .fetchUpcomingEvents(orgId: orgId.data!),
                                builder: (context, upcomingEvents) {
                                  if (upcomingEvents.hasData) {
                                    return EventsOrgList(
                                        events: upcomingEvents.data!);
                                  } else if (upcomingEvents.hasError) {
                                    print(
                                        " --- err dfdfsdgh : ${upcomingEvents.error}");
                                    return Center(
                                        child: Icon(Icons.error,
                                            color: AppColor.theme));
                                  } else {
                                    return Center(
                                        child: Image.asset(Images.loadingGif));
                                  }
                                }),
                            StreamBuilder<List<EventModel>>(
                                stream: FireServices.instance
                                    .fetchPastEvents(orgId: orgId.data!),
                                builder: (context, pastEvents) {
                                  if (pastEvents.hasData) {
                                    return EventsOrgList(
                                        events: pastEvents.data ?? []);
                                  } else if (pastEvents.hasError) {
                                    print(
                                        " --- err df5adfs : ${pastEvents.error}");
                                    return Center(
                                        child: Icon(Icons.error,
                                            color: AppColor.theme));
                                  } else {
                                    return Center(
                                        child: Image.asset(Images.loadingGif));
                                  }
                                }),
                          ],
                        );
                      } else if (orgId.hasError) {
                        print(" --- err dfkjlaiejlkf : ${orgId.error}");
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
