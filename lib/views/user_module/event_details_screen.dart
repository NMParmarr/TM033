import 'package:eventflow/data/datasource/services/firebase/firebase_services.dart';
import 'package:eventflow/data/models/event_model.dart';
import 'package:eventflow/data/models/organizer_model.dart';
import 'package:eventflow/utils/common_utils.dart';
import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/datasource/services/connection/network_checker_widget.dart';
import '../../data/models/user_model.dart';
import '../../resources/helper/shared_preferences.dart';
import '../../utils/common_flushbar.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/gap.dart';
import '../../utils/text.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;
  final String orgId;
  const EventDetailsScreen(
      {super.key, required this.eventId, required this.orgId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EventModel>(
        stream: FireServices.instance
            .fetchEventByEventId(orgId: widget.orgId, eventId: widget.eventId),
        builder: (context, event) {
          if (event.hasData) {
            return NetworkCheckerWidget(
                child: _contentWidget(context, event: event.data!));
          } else if (event.hasError) {
            print(" --- err eventhiuh snap -- ${event.error}");
            return Container(
                color: Colors.white,
                child: Center(child: Icon(Icons.error, color: AppColor.theme)));
          } else {
            return Container(
                color: Colors.white,
                child: Center(child: Image.asset(Images.loadingGif)));
          }
        });
  }

  Widget _contentWidget(BuildContext context, {required EventModel event}) {
    final formattedTodayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());

    return Scaffold(
      bottomNavigationBar: Visibility(
        visible: FireServices.instance
            .isAfterOrToday(event.eventDate!, formattedTodayDate),
        child: Container(
            margin: EdgeInsets.only(
                left: 2.w, right: 2.w, bottom: 0.5.h, top: 0.5.h),
            child: FutureBuilder<String?>(
                future: Shared_Preferences.prefGetString(App.id, ""),
                builder: (context, userId) {
                  if (userId.hasData) {
                    return StreamBuilder<UserModel>(
                        stream: FireServices.instance
                            .fetchSingleUser(id: userId.data!),
                        builder: (context, user) {
                          return StreamBuilder<bool>(
                              stream: FireServices.instance.isUserJoinedEvent(
                                  orgId: widget.orgId,
                                  eventId: widget.eventId,
                                  userId: userId.data!),
                              builder: (context, isUserJoined) {
                                return ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            (isUserJoined.connectionState ==
                                                    ConnectionState.waiting)
                                                ? Colors.grey
                                                : (isUserJoined.hasData &&
                                                        isUserJoined.data!)
                                                    ? AppColor.orange
                                                    : AppColor.primary),
                                    onPressed: () async {
                                      if ((isUserJoined.hasData &&
                                          isUserJoined.data!)) {
                                        await Utils.leaveConfirmationDialog(
                                            context,
                                            orgId: widget.orgId,
                                            eventId: widget.eventId,
                                            userId: userId.data!);
                                      } else {
                                        if (!user.data!.isProfileCompleted!) {
                                          showFlushbar(context,
                                              "Complete your profile to join the event..!");
                                          return;
                                        }
                                        await Utils.joinConfirmationDialog(
                                            context,
                                            orgId: widget.orgId,
                                            eventId: widget.eventId,
                                            userId: userId.data!);
                                      }
                                    },
                                    icon: (isUserJoined.connectionState ==
                                            ConnectionState.waiting)
                                        ? SizedBox()
                                        : Icon(
                                            (isUserJoined.hasData &&
                                                    isUserJoined.data!)
                                                ? Icons
                                                    .arrow_circle_left_outlined
                                                : Icons.login,
                                            color: Colors.white,
                                          ),
                                    label: (isUserJoined.connectionState ==
                                            ConnectionState.waiting)
                                        ? CircularProgressIndicator(
                                            color: Colors.white)
                                        : Txt(
                                            isUserJoined.hasData &&
                                                    (isUserJoined.data!)
                                                ? "Leave"
                                                : "Join",
                                            textColor: Colors.white));
                              });
                        });
                  } else if (userId.hasError) {
                    return Center(
                        child: Icon(Icons.error, color: AppColor.theme));
                  } else {
                    return Center(child: Image.asset(Images.loadingGif));
                  }
                })),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 1.w, vertical: 2.w),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                          Icons.arrow_back_ios_new_rounded),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: CircleBorder()),
                                    ),
                                  ),
                                  Expanded(
                                    child: InteractiveViewer(
                                        child: Image.asset(Images.sampleEvent)),
                                  ),
                                  SizedBox(height: 5.h)
                                ],
                              );
                            });
                      },
                      child: Container(
                          width: double.infinity,
                          child: Image.asset(
                            Images.sampleEvent,
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  // Container(
                  //   height: 1.5.h,
                  //   width: 100.w,
                  //   child: Image.asset(Images.sampleImage,
                  //       fit: BoxFit.cover),
                  // ),
                  Transform.translate(
                    offset: Offset(0, 1.h),
                    child: Container(
                      width: 100.w,
                      // height: 50.h,
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
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
                            event.eventName ?? "--",
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
                                "${event.eventDate ?? "--"} ${event.eventTime ?? "--"}",
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
                                event.location ?? "--",
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
                            event.about ?? "---\n-----",
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
                          StreamBuilder<OrganizerModel>(
                              stream: FireServices.instance
                                  .fetchSingleOrganizer(id: event.orgId!),
                              builder: (context, org) {
                                return ListTile(
                                  title: Txt(org.data?.organizer ?? "--",
                                      fontsize: 2.t,
                                      fontweight: FontWeight.w500),
                                  subtitle: Txt("Event Manager",
                                      fontsize: 1.5.t,
                                      fontweight: FontWeight.w400),
                                  leading: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  Images.sampleImage),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                );
                              }),
                          VGap(2.h),
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
