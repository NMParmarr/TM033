import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/views/user_module/event_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            Tab(text: "Upcoming"),
            Tab(text: "Past"),
          ]),
          VGap(2.h),
          Expanded(child: TabBarView(children: [
            EventsList(),
            EventsList(),
          ],))
        ]),
      ),
    );
  }
}