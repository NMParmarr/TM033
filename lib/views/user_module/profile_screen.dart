import 'package:eventflow/data/models/organizer_model.dart';
import 'package:eventflow/resources/helper/loader.dart';
import 'package:eventflow/resources/helper/shared_preferences.dart';
import 'package:eventflow/resources/routes/routes.dart';
import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:eventflow/views/user_module/event_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/datasource/services/connection/network_checker_widget.dart';
import '../../data/datasource/services/firebase/firebase_services.dart';
import '../../data/models/event_model.dart';
import '../../data/models/user_model.dart';
import '../../utils/common_utils.dart';
import '../../utils/constants/app_constants.dart';
import '../../viewmodels/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return NetworkCheckerWidget(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: Shared_Preferences.prefGetString(App.id, ""),
          builder: (context, userId) {
            if (userId.hasData) {
              return StreamBuilder<UserModel>(
                  stream: FireServices.instance.fetchSingleUser(id: userId.data!),
                  builder: (context, currentUserSnap) {
                    if (currentUserSnap.hasData) {
                      return _contentWidget(context,
                          user: currentUserSnap.data, userId: userId.data!);
                    } else if (currentUserSnap.hasError) {
                      print(
                          " --- err currentusersnap : ${currentUserSnap.error}");
                      return Center(
                        child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 30.h),
                            child: Column(
                              children: [
                                Icon(Icons.error),
                                Txt("Something went wrong..!",
                                    textColor: AppColor.theme)
                              ],
                            )),
                      );
                    } else {
                      return Center(child: Image.asset(Images.loadingGif));
                    }
                  });
            } else if (userId.hasError) {
              return Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    child: Column(
                      children: [
                        Icon(Icons.error),
                        Txt("Something went wrong..!", textColor: AppColor.theme)
                      ],
                    )),
              );
            } else {
              return Center(child: Image.asset(Images.loadingGif));
            }
          },
        ),
      ),
    );
  }

  DefaultTabController _contentWidget(BuildContext context,
      {required UserModel? user, required String userId}) {
    return DefaultTabController(
      length: 2,
      child: Column(children: [
        VGap(1.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            children: [
              Hero(
                tag: "userprofile",
                child: CircleAvatar(
                  radius: 9.w,
                  backgroundImage: AssetImage(Images.sampleImage),
                ),
              ),
              HGap(5.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Txt(user?.name ?? "--",
                      textColor: Colors.black, fontsize: 2.4.t),
                  Txt(user?.mobile != null ? "+91 ${user?.mobile}" : "--",
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
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.editProfile,
                            arguments: {'user': user});
                      },
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Txt("Edit Profile", textColor: Colors.white))),
              HGap(2.w),
              Expanded(child:
                  Consumer<AuthProvider>(builder: (context, provider, _) {
                return Builder(builder: (context) {
                  return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.orange,
                      ),
                      onPressed: () async {
                        Utils.logoutConfirmationDialoag(context,
                            onYes: () async {
                          if (!provider.logoutLoading) {
                            // showLoader(context);
                            final res = await provider.logout();
                            // hideLoader();
                            if (res) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, Routes.auth, (route) => false);
                            }
                          }
                        });
                      },
                      icon: Icon(Icons.arrow_circle_left_outlined,
                          color: Colors.white),
                      label: Txt("Logout", textColor: Colors.white));
                });
              }))
            ],
          ),
        ),
        TabBar(
            labelStyle: GoogleFonts.philosopher(),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: "Events"),
              Tab(text: "About"),
            ]),
        // VGap(1.h),
        Expanded(
            child: TabBarView(
          children: [
            FutureBuilder<List<EventModel>>(
                future: FireServices.instance.fetchJoinedAllEvents(
                    userId: user!.id!),
                builder: (context, upcomingEvents) {
                  if (upcomingEvents.hasData) {
                    return EventsList(events: upcomingEvents.data ?? []);
                  } else if (upcomingEvents.hasError) {
                    print(" --- err dfdfsdgh : ${upcomingEvents.error}");
                    return Center(
                        child: Icon(Icons.error, color: AppColor.theme));
                  } else {
                    return Center(child: Image.asset(Images.loadingGif));
                  }
                }),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: ListView(
                children: [
                  VGap(1.3.h),
                  Txt(
                    "Organization",
                    fontsize: 2.7.t,
                    fontweight: FontWeight.w600,
                    textColor: Colors.black,
                  ),
                  VGap(0.3.h),
                  StreamBuilder<OrganizerModel>(
                      stream: FireServices.instance
                          .fetchSingleOrganizer(id: user!.orgId!),
                      builder: (context, orgDataSnap) {
                        return Txt(
                          orgDataSnap.data?.organization ?? "---",
                          fontsize: 2.t,
                          textColor: Colors.black,
                        );
                      }),
                  VGap(1.3.h),
                  Txt(
                    "Birth Date",
                    fontsize: 2.7.t,
                    fontweight: FontWeight.w600,
                    textColor: Colors.black,
                  ),
                  VGap(0.3.h),
                  Builder(builder: (context) {
                    String? formattedBirthDate;
                    if (user.dob != null)
                      formattedBirthDate = DateFormat('dd MMM yyyy')
                          .format(DateTime.parse(user.dob!));
                    return Txt(
                      formattedBirthDate ?? "-- --- ----",
                      fontsize: 2.t,
                      textColor: Colors.black,
                    );
                  }),
                  VGap(1.3.h),
                  Txt(
                    "Field",
                    fontsize: 2.7.t,
                    fontweight: FontWeight.w600,
                    textColor: Colors.black,
                  ),
                  VGap(0.3.h),
                  Txt(
                    user.field ?? "---",
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
                    user.about ?? "-----\n----------",
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
                  Builder(builder: (context) {
                    String? formattedJoinedDate = DateFormat('dd MMM yyyy')
                        .format(DateTime.parse(
                            user.joinDate ?? DateTime.now().toString()));
                    return Txt(
                      formattedJoinedDate,
                      fontsize: 2.t,
                      textColor: Colors.black,
                    );
                  }),
                ],
              ),
            ),
          ],
        ))
      ]),
    );
  }
}
