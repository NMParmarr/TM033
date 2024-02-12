import 'package:eventflow/utils/common_utils.dart';
import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../../utils/gap.dart';
import '../../utils/text.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin:
            EdgeInsets.only(left: 2.w, right: 2.w, bottom: 0.5.h, top: 0.5.h),
        child: ElevatedButton.icon(
            onPressed: () {
              Utils.joinConfirmationDialog(context);
            },
            icon: Icon(
              Icons.login_sharp,
              color: Colors.white,
            ),
            label: Txt(
              "Join",
              textColor: Colors.white,
              fontsize: 2.4.t,
              fontweight: FontWeight.w500,
            )),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      height: 45.h,
                      child: Image.asset(
                        Images.sampleImage,
                        fit: BoxFit.cover,
                      )),
                  Container(
                    height: 1.5.h,
                    width: 100.w,
                    child: Image.asset(Images.sampleImage, fit: BoxFit.cover),
                  ),
                  Transform.translate(
                    offset: Offset(0, -1.5.h),
                    child: Container(
                      width: 100.w,
                      // height: 50.h,
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VGap(1.h),
                          Txt(
                            "Event Name",
                            fontsize: 3.t,
                            fontweight: FontWeight.w700,
                            textColor: Colors.black,
                          ),
                          VGap(1.3.h),
                          Row(
                            children: [
                              Icon(Icons.watch_later_outlined,
                                  color: AppColor.primary),
                              HGap(3.w),
                              Txt(
                                "02-02-2024  03:30",
                                fontsize: 2.t,
                                textColor: Colors.black,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  color: AppColor.primary),
                              HGap(3.w),
                              Txt(
                                "Rajkot",
                                fontsize: 2.t,
                                textColor: Colors.black,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.groups_2, color: AppColor.primary),
                              HGap(3.w),
                              Txt(
                                "23 Participants",
                                fontsize: 2.t,
                                textColor: Colors.black,
                              )
                            ],
                          ),
                          VGap(1.3.h),
                          Txt(
                            "About",
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
                            "Organizer",
                            fontsize: 2.7.t,
                            fontweight: FontWeight.w600,
                            textColor: Colors.black,
                          ),
                          VGap(0.6.h),
                          ListTile(
                            title: Txt("Neon Parmar",
                                fontsize: 2.t, fontweight: FontWeight.w500),
                            subtitle: Txt("Event Manager",
                                fontsize: 1.5.t, fontweight: FontWeight.w400),
                            leading: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage(Images.sampleImage),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.w),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios_new_rounded),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, shape: CircleBorder()),
              ),
            )
          ],
        ),
      ),
    );
  }

 
}
