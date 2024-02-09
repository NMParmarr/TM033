import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:eventflow/utils/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'events_org_list.dart';

class HomeOrgScreen extends StatefulWidget {
  const HomeOrgScreen({super.key});

  @override
  State<HomeOrgScreen> createState() => _HomeOrgScreenState();
}

class _HomeOrgScreenState extends State<HomeOrgScreen> {
  List<String> eventTypes = [
    "All",
    "Sports",
    "Coding",
    "Festival",
    "Hakathon",
    "Debat",
    "Cooking"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: AppColor.primary),
      body: DefaultTabController(
        length: eventTypes.length,
        child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: CustomTextField(
                ctr: TextEditingController(),
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
                color: AppColor.tabbarBg,
              ),
              child: TabBar(
                  splashBorderRadius: BorderRadius.circular(10),
                  isScrollable: true,
                  dividerHeight: 0,
                  tabAlignment: TabAlignment.start,
                  dividerColor: Colors.white,
                  labelStyle: GoogleFonts.philosopher(color: Colors.white),
                  indicatorPadding:
                      EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tabs: List.generate(eventTypes.length,
                      (index) => Tab(text: eventTypes[index]))),
            ),
          ),
          VGap(1.h),
          Expanded(
            child: TabBarView(children: [
              EventsOrgList(),
              Container(child: Center(child: Txt("All"))),
              Container(child: Center(child: Txt("All"))),
              Container(child: Center(child: Txt("All"))),
              Container(child: Center(child: Txt("All"))),
              Container(child: Center(child: Txt("All"))),
              Container(child: Center(child: Txt("All"))),
            ]),
          )
        ]),
      ),
    );
  }
}
