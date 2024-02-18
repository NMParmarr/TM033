import 'package:eventflow/resources/routes/routes.dart';
import 'package:eventflow/utils/common_utils.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:flutter/material.dart';

import '../../data/models/event_model.dart';

class EventsOrgList extends StatelessWidget {
  final List<EventModel> events;
  const EventsOrgList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return events.length <= 0
        ? Utils.noDataFoundWidget(msg: "No Events Found..!")
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
                          color: Colors.black.withOpacity(0.6),
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
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Txt(
                                "23",
                                textColor: Colors.white,
                                fontweight: FontWeight.w600,
                                fontsize: 2.5.t,
                              ),
                              Txt("Participants", textColor: Colors.white),
                            ],
                          )
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
