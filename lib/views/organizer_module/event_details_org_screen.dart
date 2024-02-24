import 'package:eventflow/data/datasource/services/firebase/firebase_services.dart';
import 'package:eventflow/data/models/event_model.dart';
import 'package:eventflow/data/models/participant.dart';
import 'package:eventflow/globles.dart';
import 'package:eventflow/resources/helper/loader.dart';
import 'package:eventflow/utils/common_flushbar.dart';
import 'package:eventflow/utils/common_toast.dart';
import 'package:eventflow/utils/common_utils.dart';
import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/widgets/custom_network_image.dart';
import 'package:eventflow/views/organizer_module/paricipants_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/datasource/services/connection/network_checker_widget.dart';
import '../../resources/routes/routes.dart';
import '../../utils/gap.dart';
import '../../utils/text.dart';
import '../../viewmodels/providers/home_provider.dart';

class EventDetailsOrgScreen extends StatefulWidget {
  final String eventId;
  final String orgId;
  const EventDetailsOrgScreen({super.key, required this.eventId, required this.orgId});

  @override
  State<EventDetailsOrgScreen> createState() => _EventDetailsOrgScreenState();
}

class _EventDetailsOrgScreenState extends State<EventDetailsOrgScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EventModel>(
        stream: FireServices.instance.fetchEventByEventId(orgId: widget.orgId, eventId: widget.eventId),
        builder: (context, event) {
          if (event.hasData) {
            return NetworkCheckerWidget(child: _contentWidget(context, event: event.data!));
          } else if (event.hasError) {
            print(" --- err eventhiuh snap -- ${event.error}");
            return Container(color: Colors.white, child: Center(child: Icon(Icons.error, color: AppColor.theme)));
          } else {
            return Container(color: Colors.white, child: Center(child: Image.asset(Images.loadingGif)));
          }
        });
  }

  Widget _contentWidget(BuildContext context, {required EventModel event}) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, automaticallyImplyLeading: false),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.2.h),
        child: Row(
          children: [
            Expanded(
              child: Consumer<HomeProvider>(builder: (context, provider, _) {
                return ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pushNamed(context, Routes.addEvent, arguments: {'updateEvent': event});
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: Txt(
                      "Edit",
                      textColor: Colors.white,
                      fontsize: 2.4.t,
                      fontweight: FontWeight.w500,
                    ));
              }),
            ),
            HGap(2.w),
            Expanded(
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColor.orange),
                  onPressed: () {
                    Utils.deleteConfirmationDialoag(context, eventName: event.eventName!, onDeleteEvent: () async {
                      showLoader(context);
                      try {
                        await FireServices.instance.deleteEvent(orgId: event.orgId!, eventId: event.eventId!);
                        hideLoader();
                        Navigator.pop(context);
                        await showFlushbar(context, "'${event.eventName!}' event has been deleted.!", duration: Duration(milliseconds: 1500));
                      } catch (e) {
                        hideLoader();
                        showToastSnackbarError(context, "Some error occured..try again later.!");
                      }
                    });
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
                    child: InkWell(
                      onTap: () {
                        if (event.image == null || event.image?.trim() == "") {
                          showToast("No Image.!");
                          return;
                        }
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.w),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.arrow_back_ios_new_rounded),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: CircleBorder()),
                                    ),
                                  ),
                                  Expanded(
                                    child: InteractiveViewer(
                                        child: (event.image == null || event.image?.trim() == "")
                                            ? Container(
                                                child: Image.asset(
                                                Images.imagePlaceholder,
                                                fit: BoxFit.contain,
                                              ))
                                            : CustomNetworkImage(
                                                url: event.image!,
                                                borderRadius: 0,
                                                fit: BoxFit.contain,
                                              )),
                                  ),
                                  SizedBox(height: 5.h)
                                ],
                              );
                            });
                      },
                      child: (event.image == null || event.image?.trim() == "")
                          ? Container(
                              width: double.infinity,
                              child: Image.asset(
                                Images.imagePlaceholder,
                                fit: BoxFit.cover,
                              ))
                          : CustomNetworkImage(
                              url: event.image!,
                              width: double.infinity,
                              borderRadius: 0,
                            ),
                    ),
                  ),
                  // Transform.flip(
                  //   child: Container(
                  //     height: 20.h,
                  //     width: 100.w,
                  //     child: Image.asset(Images.sampleEvent, fit: BoxFit.fill),
                  //   ),
                  // ),
                  Transform.translate(
                    offset: Offset(0, 1.h),
                    child: Container(
                      width: 100.w,
                      // height: 50.h,
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey.withOpacity(0.5), offset: Offset(0, -5))],
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
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
                              Icon(Icons.watch_later_outlined, color: AppColor.primary),
                              HGap(3.w),
                              Builder(builder: (context) {
                                final date = getFormattedDate(date: event.eventDate);
                                final time = event.eventTime != null ? get12HrsTime(context, time: event.eventTime!) : "--:--";
                                return Txt(
                                  "$date  $time",
                                  fontsize: 2.t,
                                  textColor: Colors.black,
                                );
                              })
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, color: AppColor.primary),
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
                              StreamBuilder<List<Participant>>(
                                  stream: FireServices.instance.fetchJoinedParticipants(orgId: widget.orgId, eventId: widget.eventId),
                                  builder: (context, participants) {
                                    return Txt(
                                      "${participants.data?.length ?? "--"} ${participants.data != null && participants.data!.length == 1 ? "Participant" : "Participants"}",
                                      fontsize: 2.t,
                                      textColor: Colors.black,
                                    );
                                  })
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
                                  event.about ?? "---\n-----",
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
                          StreamBuilder<List<Participant>>(
                              stream: FireServices.instance.fetchJoinedParticipants(orgId: widget.orgId, eventId: widget.eventId),
                              builder: (context, participants) {
                                if (participants.hasData) {
                                  return ParticipantsList(
                                    participants: participants.data ?? [],
                                  );
                                } else if (participants.hasError) {
                                  return Center(child: Icon(Icons.error, color: AppColor.theme));
                                } else {
                                  return Center(child: CircularProgressIndicator(color: AppColor.theme));
                                }
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: CircleBorder()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
