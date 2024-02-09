import 'package:eventflow/resources/routes/routes.dart';
import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:eventflow/views/organizer_module/paricipants_list.dart';
import 'package:eventflow/views/user_module/event_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrgProfileScreen extends StatefulWidget {
  const OrgProfileScreen({super.key});

  @override
  State<OrgProfileScreen> createState() => _OrgProfileScreenState();
}

class _OrgProfileScreenState extends State<OrgProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              children: [
                Hero(
                  tag: "orgprofile",
                  child: CircleAvatar(
                    radius: 9.w,
                    backgroundImage: AssetImage(Images.sampleImage),
                  ),
                ),
                HGap(5.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Txt("Organization Name",
                        textColor: Colors.black, fontsize: 2.4.t),
                    Txt("organizationmail@gmail.com",
                        textColor: Colors.black, fontsize: 1.7.t)
                  ],
                )
              ],
            ),
          ),
          VGap(1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.editProfile);
                        },
                        icon: Icon(Icons.edit, color: Colors.white),
                        label: Txt("Edit Profile", textColor: Colors.white))),
                HGap(2.w),
                Expanded(
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.orange,
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.login, (route) => false);
                        },
                        icon: Icon(Icons.arrow_circle_left_outlined,
                            color: Colors.white),
                        label: Txt("Logout", textColor: Colors.white)))
              ],
            ),
          ),
          TabBar(
              labelStyle: GoogleFonts.philosopher(),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: "Users"),
                Tab(text: "About"),
              ]),
          // VGap(1.h),
          Expanded(
              child: TabBarView(
            children: [
              Scaffold(
                body: SingleChildScrollView(child: ParticipantsList()),
                floatingActionButton: FloatingActionButton(
                    onPressed: () {}, child: Icon(Icons.group_add_outlined)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: ListView(
                  children: [
                    VGap(1.3.h),
                    Txt(
                      "Birth Date",
                      fontsize: 2.7.t,
                      fontweight: FontWeight.w600,
                      textColor: Colors.black,
                    ),
                    VGap(0.3.h),
                    Txt(
                      "DD MMM YYYY",
                      fontsize: 2.t,
                      textColor: Colors.black,
                    ),
                    VGap(1.3.h),
                    Txt(
                      "Field",
                      fontsize: 2.7.t,
                      fontweight: FontWeight.w600,
                      textColor: Colors.black,
                    ),
                    VGap(0.3.h),
                    Txt(
                      "Information Technology",
                      fontsize: 2.t,
                      textColor: Colors.black,
                    ),
                    VGap(1.3.h),
                    Txt(
                      "Bio",
                      fontsize: 2.7.t,
                      fontweight: FontWeight.w600,
                      textColor: Colors.black,
                    ),
                    VGap(0.3.h),
                    Txt(
                      "Lorem is put hthjdjf djfh jkh fdkj r kfho ieor hdfi poer kjdfoueoj a;lkfkhfg kerkh iadknkjhd uaekjkjahdiu hkenj hoij kjehri jkjhfiuej keu e hjjflkadj oaj pioajf oaheupo jaeiufh iodjf ajdf .",
                      fontsize: 2.t,
                      textColor: Colors.black,
                    ),
                    VGap(1.3.h),
                    Txt(
                      "Join Date",
                      fontsize: 2.7.t,
                      fontweight: FontWeight.w600,
                      textColor: Colors.black,
                    ),
                    VGap(0.3.h),
                    Txt(
                      "DD MMM YYYY",
                      fontsize: 2.t,
                      textColor: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ))
        ]),
      ),
    );
  }
}
