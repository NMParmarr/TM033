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

import '../../utils/widgets/custom_text_field.dart';

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
                          Navigator.pushNamed(context, Routes.editOrgProfile);
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
                body: SingleChildScrollView(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: ParticipantsList(),
                )),
                floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                  left: 3.w,
                                  right: 3.w,
                                  top: 2.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Txt(
                                      "Add New User",
                                      fontsize: 2.7.t,
                                      fontweight: FontWeight.w600,
                                      textColor: Colors.black,
                                    ),
                                  ),
                                  VGap(2.h),
                                  Txt("Full Name",
                                      textColor: Colors.black,
                                      fontsize: 2.t,
                                      fontweight: FontWeight.w500),
                                  CustomTextField(ctr: TextEditingController()),
                                  VGap(1.5.h),
                                  Txt("Mobile",
                                      textColor: Colors.black,
                                      fontsize: 2.t,
                                      fontweight: FontWeight.w500),
                                  CustomTextField(ctr: TextEditingController()),
                                  VGap(2.h),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 155, 155, 155),
                                              ),
                                              onPressed: () {},
                                              icon: Icon(Icons.close,
                                                  color: Colors.white),
                                              label: Txt("Cancel",
                                                  textColor: Colors.white))),
                                      HGap(2.w),
                                      Expanded(
                                          child: ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColor.theme,
                                              ),
                                              onPressed: () {},
                                              icon: Icon(
                                                  Icons.person_add_alt_1_sharp,
                                                  color: Colors.white),
                                              label: Txt("Add",
                                                  textColor: Colors.white))),
                                    ],
                                  ),
                                  VGap(2.h)
                                ],
                              ));
                        },
                      );
                    },
                    child: Icon(Icons.group_add_outlined)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: ListView(
                  children: [
                    VGap(1.3.h),
                    Txt(
                      "Organization Name",
                      fontsize: 2.5.t,
                      fontweight: FontWeight.w600,
                      textColor: Colors.black,
                    ),
                    VGap(0.3.h),
                    Txt(
                      "Neotech Pvt Ltd",
                      fontsize: 2.t,
                      textColor: Colors.black,
                    ),
                    VGap(1.3.h),
                    Txt(
                      "Mobile",
                      fontsize: 2.5.t,
                      fontweight: FontWeight.w600,
                      textColor: Colors.black,
                    ),
                    VGap(0.3.h),
                    Txt(
                      "+91 8141809076",
                      fontsize: 2.t,
                      textColor: Colors.black,
                    ),
                    VGap(1.3.h),
                    Txt(
                      "About",
                      fontsize: 2.5.t,
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
                      fontsize: 2.5.t,
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
