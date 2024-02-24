import 'package:eventflow/data/datasource/services/firebase/firebase_services.dart';
import 'package:eventflow/data/models/participant.dart';
import 'package:eventflow/globles.dart';
import 'package:eventflow/resources/routes/routes.dart';
import 'package:eventflow/utils/common_utils.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:eventflow/utils/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/event_model.dart';

class EventsOrgList extends StatelessWidget {
  final List<EventModel> events;
  const EventsOrgList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return events.length <= 0
        ? SingleChildScrollView(
            child: Utils.noDataFoundWidget(msg: "No Events Found..!"))
        : ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Routes.eventDetailsOrg,
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
                          url: events[index].image!,
                          child: _eventDetailContainer(index),
                        ),
                ),
              );
            },
          );
  }

  Widget _eventDetailContainer(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
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
          StreamBuilder<List<Participant>>(
              stream: FireServices.instance.fetchJoinedParticipants(
                  orgId: events[index].orgId!, eventId: events[index].eventId!),
              builder: (context, participants) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Txt(
                      participants.data?.length.toString() ?? "--",
                      textColor: Colors.white,
                      fontweight: FontWeight.w600,
                      fontsize: 2.5.t,
                    ),
                    Txt("${participants.data != null && participants.data!.length == 1 ? "Participant" : "Participants"}",
                        textColor: Colors.white),
                  ],
                );
              })
        ],
      ),
    );
  }
}
