import 'package:eventflow/data/datasource/services/firebase/firebase_services.dart';
import 'package:eventflow/data/models/event_type.dart';
import 'package:eventflow/resources/helper/shared_preferences.dart';
import 'package:eventflow/resources/routes/routes.dart';
import 'package:eventflow/utils/constants/app_constants.dart';
import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/widgets/custom_text_field.dart';
import 'package:eventflow/viewmodels/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/datasource/services/connection/network_checker_widget.dart';
import '../../data/models/event_model.dart';
import '../../utils/text.dart';
import 'events_org_list.dart';

class HomeOrgScreen extends StatefulWidget {
  const HomeOrgScreen({super.key});

  @override
  State<HomeOrgScreen> createState() => _HomeOrgScreenState();
}

class _HomeOrgScreenState extends State<HomeOrgScreen> {
  // final formattedTodayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
  TextEditingController? _searchCtr;

  @override
  void initState() {
    super.initState();
    _searchCtr = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtr?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NetworkCheckerWidget(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.addEvent);
          },
          child: Icon(Icons.post_add_rounded),
        ),
        body: FutureBuilder<String?>(
            future: Shared_Preferences.prefGetString(App.id, ""),
            builder: (context, orgId) {
              if (orgId.hasData) {
                return StreamBuilder<List<EventType>>(
                    stream: FireServices.instance.fetchEventTypeByOrg(orgId: orgId.data!),
                    builder: (context, typeSnap) {
                      if (typeSnap.hasData) {
                        return _contentWidget(eventTypes: typeSnap.data!, orgId: orgId.data!);
                      } else if (orgId.hasError) {
                        print(" --- err event type snap -- ${orgId.error}");
                        return Center(child: Icon(Icons.error, color: AppColor.theme));
                      } else {
                        return Center(child: Image.asset(Images.loadingGif));
                      }
                    });
              } else if (orgId.hasError) {
                print(" --- err org id snap -- ${orgId.error}");
                return Center(child: Icon(Icons.error, color: AppColor.theme));
              } else {
                return Center(child: Image.asset(Images.loadingGif));
              }
            }),
      ),
    );
  }

  Widget welcomeScreen() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Images.welcomGif,
            height: 30.h,
          ),
          Txt(
            "Welcome to",
            fontsize: 4.t,
            textColor: AppColor.theme,
            fontweight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          Txt(
            "EventFlow ..!",
            fontsize: 5.t,
            textColor: AppColor.theme,
            fontweight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          VGap(2.h),
          Txt(
            "Start publishing your upcoming events by clicking below button..!",
            textAlign: TextAlign.center,
            fontsize: 2.t,
          )
        ],
      ),
    );
  }

  Widget _contentWidget({required List<EventType> eventTypes, required String orgId}) {
    eventTypes.insert(0, EventType(name: "All"));
    return eventTypes.length <= 1
        ? welcomeScreen()
        : DefaultTabController(
            length: eventTypes.length,
            child: Column(children: [
              VGap(1.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Consumer<HomeProvider>(builder: (context, provider, _) {
                  return CustomTextField(
                    ctr: _searchCtr!,
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search",
                    contentPadding: EdgeInsets.zero,
                    tapOutsideDismiss: true,
                    onChanged: (value) {
                      provider.updateSearchQuery(newQuery: value);
                    },
                  );
                }),
              ),
              VGap(1.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Container(
                  height: 5.h,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey.withOpacity(0.2)
                      // color: AppColor.tabbarBg,
                      ),
                  child: TabBar(
                      splashBorderRadius: BorderRadius.circular(10),
                      isScrollable: true,
                      dividerHeight: 0,
                      tabAlignment: TabAlignment.start,
                      dividerColor: Colors.white,
                      labelStyle: GoogleFonts.philosopher(color: Colors.white),
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      tabs: List.generate(eventTypes.length, (index) => Tab(text: eventTypes[index].name))),
                ),
              ),
              VGap(1.h),
              Expanded(
                child: TabBarView(
                    children: List.generate(
                        eventTypes.length,
                        (index) => StreamBuilder<List<EventModel>>(
                            stream: index == 0
                                ? FireServices.instance.fetchAllEventsByOrgId(orgId: orgId)
                                : FireServices.instance.fetchEventsByTypeId(
                                    orgId: eventTypes[index].orgId!,
                                    typeId: eventTypes[index].typeId!,
                                  ),
                            builder: (context, eventSnap) {
                              if (eventSnap.hasData) {
                                return Consumer<HomeProvider>(builder: (context, provider, _) {
                                  return EventsOrgList(
                                      onRefresh: () async {
                                        provider.refresh();
                                      },
                                      events: provider.searchQueryString == ""
                                          ? eventSnap.data!
                                          : eventSnap.data!.where((element) => element.eventName!.toLowerCase().contains(provider.searchQueryString)).toList());
                                });
                              } else if (eventSnap.hasError) {
                                print(" --- err events snap -- ${eventSnap.error}");
                                return Center(child: Icon(Icons.error, color: AppColor.theme));
                              } else {
                                return Center(child: Image.asset(Images.loadingGif));
                              }
                            }))),
              )
            ]),
          );
  }
}
