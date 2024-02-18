import 'package:eventflow/data/datasource/services/firebase_services.dart';
import 'package:eventflow/data/models/user_model.dart';
import 'package:eventflow/resources/helper/shared_preferences.dart';
import 'package:eventflow/resources/routes/routes.dart';
import 'package:eventflow/utils/common_flushbar.dart';
import 'package:eventflow/utils/constants/app_constants.dart';
import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:flutter/material.dart';

import '../../data/models/event_model.dart';
import '../../utils/common_toast.dart';
import '../../utils/common_utils.dart';

class EventsList extends StatelessWidget {
  final List<EventModel> events;
  const EventsList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return events.length <= 0
        ? Utils.noDataFoundWidget(msg: "No Events Found..!")
        : ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Routes.eventDetails, arguments: {
                    'orgId': events[index].orgId!,
                    'eventId': events[index].eventId!
                  });
                },
                child: Card(
                  elevation: 3,
                  margin:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: 23.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        // boxShadow: [BoxShadow(blurRadius: 6, color: Colors.grey)],
                        image: DecorationImage(
                            image: AssetImage(Images.sampleEvent),
                            fit: BoxFit.cover)),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.3.h),
                      decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Txt(
                                events[index].eventName ?? "--",
                                fontsize: 2.4.t,
                                fontweight: FontWeight.w600,
                                textColor: Colors.white,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.watch_later_outlined,
                                      size: 2.h, color: Colors.white),
                                  HGap(2.w),
                                  Txt(
                                    "${events[index].eventDate ?? "--"} ${events[index].eventTime ?? "--"}",
                                    fontsize: 1.6.t,
                                    textColor: Colors.white,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      size: 2.h, color: Colors.white),
                                  HGap(2.w),
                                  Txt(
                                    events[index].location ?? "--",
                                    fontsize: 1.6.t,
                                    textColor: Colors.white,
                                  )
                                ],
                              )
                            ],
                          ),
                          FutureBuilder<String?>(
                              future:
                                  Shared_Preferences.prefGetString(App.id, ""),
                              builder: (context, userId) {
                                if (userId.hasData) {
                                  return StreamBuilder<UserModel>(
                                      stream: FireServices.instance
                                          .fetchSingleUser(id: userId.data!),
                                      builder: (context, user) {
                                        return StreamBuilder<bool>(
                                            stream: FireServices.instance
                                                .isUserJoinedEvent(
                                                    orgId: events[index].orgId!,
                                                    eventId:
                                                        events[index].eventId!,
                                                    userId: userId.data!),
                                            builder: (context, isUserJoined) {
                                              return ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor: (isUserJoined
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting)
                                                              ? Colors.grey
                                                              : (isUserJoined
                                                                          .hasData &&
                                                                      isUserJoined
                                                                          .data!)
                                                                  ? AppColor
                                                                      .orange
                                                                  : AppColor
                                                                      .primary),
                                                  onPressed: () async {
                                                    if ((isUserJoined.hasData &&
                                                        isUserJoined.data!)) {
                                                      await Utils
                                                          .leaveConfirmationDialog(
                                                              context,
                                                              orgId:
                                                                  events[index]
                                                                      .orgId!,
                                                              eventId:
                                                                  events[index]
                                                                      .eventId!,
                                                              userId:
                                                                  userId.data!);
                                                    } else {
                                                      if (!user.data!
                                                          .isProfileCompleted!) {
                                                        showFlushbar(context,
                                                            "Complete your profile to join the event..!");
                                                        return;
                                                      }
                                                      await Utils
                                                          .joinConfirmationDialog(
                                                              context,
                                                              orgId:
                                                                  events[index]
                                                                      .orgId!,
                                                              eventId:
                                                                  events[index]
                                                                      .eventId!,
                                                              userId:
                                                                  userId.data!);
                                                    }
                                                  },
                                                  icon: (isUserJoined
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting)
                                                      ? SizedBox()
                                                      : Icon(
                                                          (isUserJoined
                                                                      .hasData &&
                                                                  isUserJoined
                                                                      .data!)
                                                              ? Icons
                                                                  .arrow_circle_left_outlined
                                                              : Icons.login,
                                                          color: Colors.white,
                                                        ),
                                                  label: (isUserJoined
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting)
                                                      ? CircularProgressIndicator(
                                                          color: Colors.white)
                                                      : Txt(
                                                          isUserJoined.hasData &&
                                                                  (isUserJoined
                                                                      .data!)
                                                              ? "Leave"
                                                              : "Join",
                                                          textColor:
                                                              Colors.white));
                                            });
                                      });
                                } else if (userId.hasError) {
                                  return Center(
                                      child: Icon(Icons.error,
                                          color: AppColor.theme));
                                } else {
                                  return Center(
                                      child: Image.asset(Images.loadingGif));
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
