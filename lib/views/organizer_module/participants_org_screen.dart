import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/views/organizer_module/events_org_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ParticipantsOrgScreen extends StatefulWidget {
  const ParticipantsOrgScreen({super.key});

  @override
  State<ParticipantsOrgScreen> createState() => _ParticipantsOrgScreenState();
}

class _ParticipantsOrgScreenState extends State<ParticipantsOrgScreen> {
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
              EventsOrgList(),
              EventsOrgList(),
            ],
          ))
        ]),
      ),
    );
  }
}
