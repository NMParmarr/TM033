import 'package:eventflow/data/datasource/services/firebase_services.dart';
import 'package:eventflow/data/models/organizer_model.dart';
import 'package:eventflow/data/models/user_model.dart';
import 'package:eventflow/resources/routes/routes.dart';
import 'package:eventflow/utils/common_flushbar.dart';
import 'package:eventflow/utils/common_utils.dart';
import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:eventflow/viewmodels/providers/home_provider.dart';
import 'package:eventflow/viewmodels/providers/profile_provider.dart';
import 'package:eventflow/views/organizer_module/paricipants_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../resources/helper/shared_preferences.dart';
import '../../utils/common_toast.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../viewmodels/providers/auth_provider.dart';

class OrgProfileScreen extends StatefulWidget {
  const OrgProfileScreen({super.key});

  @override
  State<OrgProfileScreen> createState() => _OrgProfileScreenState();
}

class _OrgProfileScreenState extends State<OrgProfileScreen> {
  TextEditingController? _newUserFullNameCtr;
  TextEditingController? _newUserMobileCtr;
  TextEditingController? _newUserPassCtr;

  @override
  void initState() {
    super.initState();
    initTextControllers();
  }

  @override
  void dispose() {
    disposeTextControllers();
    super.dispose();
  }

  void initTextControllers() {
    _newUserFullNameCtr = TextEditingController();
    _newUserMobileCtr = TextEditingController();
    _newUserPassCtr = TextEditingController();
  }

  void disposeTextControllers() {
    _newUserFullNameCtr?.dispose();
    _newUserMobileCtr?.dispose();
    _newUserPassCtr?.dispose();
  }

  void clearTextControllers() {
    _newUserFullNameCtr?.clear();
    _newUserMobileCtr?.clear();
    _newUserPassCtr?.clear();
  }

  bool validateNewUserTextFields() {
    if (_newUserFullNameCtr?.text.toString().trim() == "") {
      showToast("Enter Full Name of user");
      return false;
      //
    } else if (_newUserMobileCtr?.text.toString().trim() == "") {
      showToast("Enter Mobile number of user");
      return false;
      //
    } else if (!Utils.isValidMobile(
        mobile: _newUserMobileCtr!.text.toString().trim())) {
      showToast("Enter valid mobile number");
      return false;
      //
    } else if (_newUserPassCtr?.text.toString().trim() == "") {
      showToast("Enter Password for new user");
      return false;
      //
    } else if (!Utils.isValidLengthPassword(
        password: _newUserPassCtr!.text.toString().trim())) {
      showToast("Password must be atleast 8 char long");
      return false;
      //
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: Shared_Preferences.prefGetString(App.id, ""),
        builder: (context, orgId) {
          if (orgId.hasData) {
            return StreamBuilder<OrganizerModel>(
                stream:
                    FireServices.instance.fetchSingleOrganizer(id: orgId.data!),
                builder: (context, currentOrgSnap) {
                  if (currentOrgSnap.hasData) {
                    return _contentWidget(context,
                        org: currentOrgSnap.data, orgId: orgId.data!);
                  } else if (currentOrgSnap.hasError) {
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
          } else if (orgId.hasError) {
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
    );
  }

  Widget _contentWidget(BuildContext context,
      {required OrganizerModel? org, required String orgId}) {
    return DefaultTabController(
      length: 2,
      child: Column(children: [
        VGap(1.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            children: [
              Hero(
                tag: "orgprofile",
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
                  Txt(org?.organizer ?? "--",
                      textColor: Colors.black, fontsize: 2.4.t),
                  Txt(org?.email?.toLowerCase() ?? "--",
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
                        Navigator.pushNamed(context, Routes.editOrgProfile,
                            arguments: {'org': org});
                      },
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Txt("Edit Profile", textColor: Colors.white))),
              HGap(2.w),
              Expanded(child:
                  Consumer<AuthProvider>(builder: (context, provider, _) {
                return ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.orange,
                    ),
                    onPressed: () async {
                      Utils.logoutConfirmationDialoag(context, onYes: () async {
                        if (!provider.logoutLoading) {
                          final res = await provider.logout();
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
              }))
            ],
          ),
        ),
        TabBar(
            labelStyle: GoogleFonts.philosopher(),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: "Users"),
              Tab(text: "About"),
            ]),
        // VGap(1.h),
        Expanded(
            child: TabBarView(
          children: [
            Scaffold(
              body: SingleChildScrollView(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: StreamBuilder<List<UserModel>>(
                    stream:
                        FireServices.instance.fetchUsersByOrdId(orgId: orgId),
                    builder: (context, usersSnap) {
                      if (usersSnap.hasData) {
                        if (usersSnap.data?.length == 0) {
                          return Utils.noDataFoundWidget(
                              msg: "No Users..!",
                              alignment: Alignment.topCenter);
                        } else {
                          return ParticipantsList(
                              usersList: usersSnap.data ?? []);
                        }
                      } else if (usersSnap.hasError) {
                        print(" --- err snap userbyordid : ${usersSnap.error}");
                        return Center(
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
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
                    }),
              )),
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    _addUserBottomSheet(context, orgId: orgId);
                  },
                  child: Icon(Icons.group_add_outlined)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: ListView(
                children: [
                  VGap(1.3.h),
                  Txt("Organization Name",
                      fontsize: 2.5.t,
                      fontweight: FontWeight.w600,
                      textColor: Colors.black),
                  VGap(0.3.h),
                  Txt(org?.organization ?? "--",
                      fontsize: 2.t, textColor: Colors.black),
                  VGap(1.3.h),
                  Txt("Mobile",
                      fontsize: 2.5.t,
                      fontweight: FontWeight.w600,
                      textColor: Colors.black),
                  VGap(0.3.h),
                  Txt(org?.mobile != null ? "+91 ${org!.mobile}" : "--",
                      fontsize: 2.t, textColor: Colors.black),
                  VGap(1.3.h),
                  Txt("About",
                      fontsize: 2.5.t,
                      fontweight: FontWeight.w600,
                      textColor: Colors.black),
                  VGap(0.3.h),
                  Txt(
                    org?.about ?? "--------\n-------------",
                    fontsize: 2.t,
                    textColor: Colors.black,
                  ),
                  VGap(1.3.h),
                  Txt(
                    "Join Date",
                    fontsize: 2.5.t,
                    fontweight: FontWeight.w600,
                    textColor: Colors.black,
                  ),
                  VGap(0.3.h),
                  Builder(builder: (context) {
                    String formattedJoinedDate = DateFormat('dd MMM yyyy')
                        .format(DateTime.parse(org!.joinDate!));
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

  Future<dynamic> _addUserBottomSheet(BuildContext context,
      {required String orgId}) {
    clearTextControllers();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 3.w,
                right: 3.w,
                top: 2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Txt(
                    "Add New User",
                    fontsize: 2.7.t,
                    fontweight: FontWeight.w600,
                    textColor: Colors.black,
                  ),
                ),
                VGap(2.h),
                Txt("Full Name",
                    textColor: Colors.black,
                    fontsize: 2.t,
                    fontweight: FontWeight.w500),
                CustomTextField(
                    ctr: _newUserFullNameCtr!,
                    hintText: "Enter full name of new user",
                    capitalization: TextCapitalization.words),
                VGap(1.5.h),
                Txt("Mobile",
                    textColor: Colors.black,
                    fontsize: 2.t,
                    fontweight: FontWeight.w500),
                CustomTextField(
                  ctr: _newUserMobileCtr!,
                  hintText: "Enter mobile number of new user",
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  inputType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                ),
                VGap(1.5.h),
                Txt("Password",
                    textColor: Colors.black,
                    fontsize: 2.t,
                    fontweight: FontWeight.w500),
                CustomTextField(
                  ctr: _newUserPassCtr!,
                  hintText: "Enter password for user to login",
                  inputType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                ),
                VGap(2.h),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 155, 155, 155),
                            ),
                            onPressed: () {
                              clearTextControllers();
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close, color: Colors.white),
                            label: Txt("Cancel", textColor: Colors.white))),
                    HGap(2.w),
                    Expanded(child: Consumer<ProfileProvider>(
                        builder: (context, provider, _) {
                      return ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.theme,
                          ),
                          onPressed: () async {
                            final isValid = validateNewUserTextFields();
                            if (!isValid) return;
                            final bool res = await provider.addNewUser(
                                orgId: orgId,
                                fullName:
                                    _newUserFullNameCtr!.text.toString().trim(),
                                mobile:
                                    _newUserMobileCtr!.text.toString().trim(),
                                password:
                                    _newUserPassCtr!.text.toString().trim());
                            if (res) {
                              Navigator.pop(context);
                              clearTextControllers();
                              showFlushbar(
                                  context, "New User Added Succeesfully..!");
                            }
                          },
                          icon: provider.newUserLoading
                              ? SizedBox()
                              : Icon(Icons.person_add_alt_1_sharp,
                                  color: Colors.white),
                          label: provider.newUserLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Txt("Add", textColor: Colors.white));
                    })),
                  ],
                ),
                VGap(2.h)
              ],
            ));
      },
    );
  }
}
