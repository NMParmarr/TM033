import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:eventflow/views/user_module/event_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                CircleAvatar(
                  radius: 9.w,
                  backgroundImage: AssetImage(Images.sampleImage),
                ),
                HGap(5.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Txt("Username", textColor: Colors.black, fontsize: 2.4.t),
                    Txt("username@gmail.com",
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
                        onPressed: () {},
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        label: Txt(
                          "Edit Profile",
                          textColor: Colors.white,
                        ))),
                HGap(2.w),
                Expanded(
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 81, 0),
                        ),
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_circle_left_outlined,
                          color: Colors.white,
                        ),
                        label: Txt("Logout", textColor: Colors.white)))
              ],
            ),
          ),
          TabBar(
            labelStyle: GoogleFonts.philosopher(),
            
            indicatorSize: TabBarIndicatorSize.tab, tabs: [
            Tab(text: "Events"),
            Tab(text: "About"),
          ]),
          // VGap(1.h),
          Expanded(
              child: TabBarView(
            children: [
              EventsList(),
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
