import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/views/user_module/event_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/text.dart';

class JoinedEventsScreen extends StatefulWidget {
  const JoinedEventsScreen({super.key});

  @override
  State<JoinedEventsScreen> createState() => _JoinedEventsScreenState();
}

class _JoinedEventsScreenState extends State<JoinedEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: TabBarView(
            children: [
              EventsList(),
              EventsList(),
            ],
          ))
        ]),
      ),
    );
  }
}
