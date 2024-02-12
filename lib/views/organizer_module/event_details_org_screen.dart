import 'package:eventflow/utils/common_flushbar.dart';
import 'package:eventflow/utils/common_utils.dart';
import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/views/organizer_module/paricipants_list.dart';
import 'package:flutter/material.dart';

import '../../utils/gap.dart';
import '../../utils/text.dart';

class EventDetailsOrgScreen extends StatefulWidget {
  const EventDetailsOrgScreen({super.key});

  @override
  State<EventDetailsOrgScreen> createState() => _EventDetailsOrgScreenState();
}

class _EventDetailsOrgScreenState extends State<EventDetailsOrgScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.2.h),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  label: Txt(
                    "Edit",
                    textColor: Colors.white,
                    fontsize: 2.4.t,
                    fontweight: FontWeight.w500,
                  )),
            ),
            HGap(2.w),
            Expanded(
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.orange),
                  onPressed: () {
                    Utils.deleteConfirmationDialoag(context);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  label: Txt(
                    "Delete",
                    textColor: Colors.white,
                    fontsize: 2.4.t,
                    fontweight: FontWeight.w500,
                  )),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                        width: double.infinity,
                        child: Image.asset(
                          Images.sampleImage,
                          fit: BoxFit.cover,
                        )),
                  ),
                  Transform.flip(
                    child: Container(
                      height: 1.5.h,
                      width: 100.w,
                      child: Image.asset(Images.sampleImage, fit: BoxFit.fill),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -1.5.h),
                    child: Container(
                      width: 100.w,
                      // height: 50.h,
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 2,
                              color: Colors.grey.withOpacity(0.5),
                              offset: Offset(0, -5))
                        ],
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
                          Visibility(
                            visible: "111" == "111",
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                              ],
                            ),
                          ),
                          Txt(
                            "Participants",
                            fontsize: 2.7.t,
                            fontweight: FontWeight.w700,
                            textColor: Colors.black,
                          ),
                          ParticipantsList()
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
