import 'package:eventflow/data/datasource/services/firebase/firebase_services.dart';
import 'package:eventflow/data/models/user_model.dart';
import 'package:eventflow/globles.dart';
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
import 'package:intl/intl.dart';

import '../../data/models/event_model.dart';
import '../../utils/common_utils.dart';
import '../../utils/widgets/custom_network_image.dart';

class EventsList extends StatelessWidget {
  final List<EventModel> events;
  final bool? shrinkWrap;
  final ScrollPhysics? physics;
  final Future<void> Function() onRefresh;
  const EventsList(
      {super.key,
      required this.events,
      this.shrinkWrap,
      this.physics,
      required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return events.length <= 0
        ? SingleChildScrollView(
            child: Utils.noDataFoundWidget(msg: "No Events Found..!"))
        : RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              shrinkWrap: shrinkWrap ?? false,
              physics: physics,
              itemCount: events.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.eventDetails,
                        arguments: {
                          'orgId': events[index].orgId!,
                          'eventId': events[index].eventId!
                        });
                  },
                  child: Card(
                    elevation: 3,
                    margin:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: (events[index].image == null ||
                            events[index].image?.trim() == "")
                        ? Container(
                            alignment: Alignment.bottomCenter,
                            height: 23.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                // boxShadow: [BoxShadow(blurRadius: 6, color: Colors.grey)],
                                image: DecorationImage(
                                    image: AssetImage(Images.imagePlaceholder),
                                    fit: BoxFit.fill)),
                            child: _eventDetailContainer(index))
                        : CustomNetworkImage(
                            alignment: Alignment.bottomCenter,
                            height: 23.h,
                            borderRadius: 15,
                            url: events[index].image!,
                            child: _eventDetailContainer(index),
                          ),
                  ),
                );
              },
            ),
          );
  }

  Widget _eventDetailContainer(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
      decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
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
                  Builder(builder: (context) {
                    final date =
                        getFormattedDate(date: events[index].eventDate);
                    print("--> date : $date");
                    final time = events[index].eventTime != null
                        ? get12HrsTime(context, time: events[index].eventTime!)
                        : "--:--";
                    return Txt(
                      "$date  $time",
                      fontsize: 1.6.t,
                      textColor: Colors.white,
                    );
                  })
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
          _leaveJoinBtn(index)
        ],
      ),
    );
  }

  FutureBuilder<String?> _leaveJoinBtn(int index) {
    return FutureBuilder<String?>(
        future: Shared_Preferences.prefGetString(App.id, ""),
        builder: (context, userId) {
          if (userId.hasData) {
            return StreamBuilder<UserModel>(
                stream: FireServices.instance.fetchSingleUser(id: userId.data!),
                builder: (context, user) {
                  return StreamBuilder<bool>(
                      stream: FireServices.instance.isUserJoinedEvent(
                          orgId: events[index].orgId!,
                          eventId: events[index].eventId!,
                          userId: userId.data!),
                      builder: (context, isUserJoined) {
                        return Visibility(
                          visible: FireServices.instance.isAfterOrToday(
                              events[index].eventDate!, currentDate.toString()),
                          child: ElevatedButton.icon(
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
                                  await Utils.leaveConfirmationDialog(context,
                                      orgId: events[index].orgId!,
                                      eventId: events[index].eventId!,
                                      userId: userId.data!);
                                } else {
                                  if (!user.data!.isProfileCompleted!) {
                                    showFlushbar(context,
                                        "Complete your profile to join the event..!");
                                    return;
                                  }
                                  await Utils.joinConfirmationDialog(context,
                                      orgId: events[index].orgId!,
                                      eventId: events[index].eventId!,
                                      userId: userId.data!);
                                }
                              },
                              icon: Icon(
                                (isUserJoined.hasData && isUserJoined.data!)
                                    ? Icons.arrow_circle_left_outlined
                                    : Icons.login,
                                color: (isUserJoined.connectionState ==
                                        ConnectionState.waiting)
                                    ? Colors.grey
                                    : Colors.white,
                              ),
                              label: Txt(
                                  isUserJoined.hasData && (isUserJoined.data!)
                                      ? "Leave"
                                      : "Join",
                                  textColor: (isUserJoined.connectionState ==
                                          ConnectionState.waiting)
                                      ? Colors.grey
                                      : Colors.white)),
                        );
                      });
                });
          } else if (userId.hasError) {
            return Center(child: Icon(Icons.error, color: AppColor.theme));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
