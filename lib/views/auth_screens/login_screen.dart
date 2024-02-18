import 'package:eventflow/data/datasource/services/firebase_services.dart';
import 'package:eventflow/data/models/organizer_model.dart';
import 'package:eventflow/resources/routes/routes.dart';
import 'package:eventflow/utils/common_toast.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/constants/string_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/widgets/custom_text_field.dart';
import 'package:eventflow/viewmodels/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../utils/common_utils.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController? _userMobileCtr;
  TextEditingController? _userPassCtr;

  TextEditingController? _orgMobileCtr;
  TextEditingController? _orgPassCtr;

  @override
  void initState() {
    super.initState();
    initTextControllers();
    clearTextControllers();

    initAuthProviderMethods();
  }

  @override
  void dispose() {
    disposeTextControllers();
    super.dispose();
  }

  void initAuthProviderMethods() {
    Provider.of<AuthProvider>(context, listen: false).initOrgListSelection();
  }

  void initTextControllers() {
    _userMobileCtr = TextEditingController();
    _userPassCtr = TextEditingController();
    _orgMobileCtr = TextEditingController();
    _orgPassCtr = TextEditingController();
  }

  void disposeTextControllers() {
    _userMobileCtr?.dispose();
    _userPassCtr?.dispose();
    _orgMobileCtr?.dispose();
    _orgPassCtr?.dispose();
  }

  void clearTextControllers() {
    _userMobileCtr?.clear();
    _userPassCtr?.clear();
    _orgMobileCtr?.clear();
    _orgPassCtr?.clear();
  }

  bool validateOrgTextFields() {
    if (_orgMobileCtr?.text.toString().trim() == "") {
      showToast("Enter Mobile");
      return false;
      //
    } else if (!Utils.isValidMobile(
        mobile: _orgMobileCtr!.text.toString().trim())) {
      showToast("Enter valid mobile");
      return false;
      //
    } else if (_orgPassCtr?.text.toString().trim() == "") {
      showToast("Enter Password");
      return false;
      //
    } else if (!Utils.isValidLengthPassword(
        password: _orgPassCtr!.text.toString().trim())) {
      showToast("Password must be atleast 8 char long");
      return false;
      //
    } else if (Provider.of<AuthProvider>(context, listen: false)
            .selectedValue ==
        Strings.selectOrgTion) {
      showToast("Please select organization");
      return false;
    } else {
      return true;
    }
  }

  bool validateUserTextFields() {
    if (_userMobileCtr?.text.toString().trim() == "") {
      showToast("Enter Mobile");
      return false;
      //
    } else if (!Utils.isValidMobile(
        mobile: _userMobileCtr!.text.toString().trim())) {
      showToast("Enter valid mobile");
      return false;
      //
    } else if (_userPassCtr?.text.toString().trim() == "") {
      showToast("Enter Password");
      return false;
      //
    } else if (!Utils.isValidLengthPassword(
        password: _userPassCtr!.text.toString().trim())) {
      showToast("Password must be atleast 8 char long");
      return false;
      //
    } else if (Provider.of<AuthProvider>(context, listen: false)
            .selectedValue ==
        Strings.selectOrgTion) {
      showToast("Please select organization");
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: Scaffold(
        backgroundColor: AppColor.theme,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VGap(2.h),
                Container(
                    alignment: Alignment.center,
                    height: 25.h,
                    child: Hero(
                        tag: "AppLogo",
                        child: Image.asset(Images.applogoWithoutBg))),
                Container(
                  height: 9.h,
                  child: Txt(
                    "Event Flow",
                    fontsize: 4.t,
                    textColor: Colors.white,
                  ),
                ),
                // VGap(5.h),
                _authContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _authContainer() {
    return Container(
      height: 64.h,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: DefaultTabController(
        length: 2,
        child: Column(children: [
          TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 2.w),
              labelStyle: GoogleFonts.philosopher(
                  fontWeight: FontWeight.w600, fontSize: 1.8.t),
              tabs: [
                Tab(text: "Users", icon: Icon(Icons.group)),
                Tab(text: "Organizers", icon: Icon(Icons.manage_accounts))
              ]),
          Expanded(
            child: TabBarView(
              children: [
                _userLogin(isUserTab: true),
                _userLogin(isUserTab: false),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _userLogin({required bool isUserTab}) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VGap(2.h),
            Txt(isUserTab ? "User Login" : "Organizer Login",
                textColor: Colors.black,
                fontsize: 3.t,
                fontweight: FontWeight.bold),
            VGap(1.h),
            Txt("Mobile",
                textColor: Colors.black,
                fontsize: 2.t,
                fontweight: FontWeight.w500),
            CustomTextField(
              ctr: isUserTab ? _userMobileCtr! : _orgMobileCtr!,
              hintText: "Enter mobile",
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              inputType: TextInputType.numberWithOptions(
                  decimal: false, signed: false),
              maxLength: 10,
            ),
            VGap(1.h),
            Txt("Password",
                textColor: Colors.black,
                fontsize: 2.t,
                fontweight: FontWeight.w500),
            Consumer<AuthProvider>(builder: (context, provider, _) {
              return CustomTextField(
                  ctr: isUserTab ? _userPassCtr! : _orgPassCtr!,
                  obsecuredText: !provider.isUserPassVisible,
                  hintText: "Enter password",
                  suffixIcon: IconButton(
                    icon: provider.isUserPassVisible
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: () {
                      provider.toggleUserPass();
                    },
                  ));
            }),
            VGap(4.h),
            StreamBuilder<List<OrganizerModel>>(
                stream: FireServices.instance.fetchAllOrganizers(),
                builder: (context, orgListSnap) {
                  if (orgListSnap.hasData) {
                    Provider.of<AuthProvider>(context, listen: false)
                        .setOrgList(
                            orgListData: orgListSnap.data ?? [], listen: false);
                  }
                  return Consumer<AuthProvider>(
                      builder: (context, provider, _) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)),
                      width: double.infinity,
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              value: provider.selectedValue,
                              items: List.generate(
                                  provider.orgList.length,
                                  (index) => DropdownMenuItem<String>(
                                      value:
                                          provider.orgList[index].organization,
                                      child: Txt(provider
                                              .orgList[index].organization ??
                                          "--"))),
                              onChanged: (newValue) {
                                provider.setDropdownValue(value: newValue!);
                              })),
                    );
                  });
                }),
            VGap(3.h),
            Consumer<AuthProvider>(builder: (context, provider, _) {
              return Container(
                width: 100.w,
                height: 6.h,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.theme,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      try {
                        if (isUserTab) {
                          bool isValid = validateUserTextFields();
                          if (!isValid) return;
                          if (!provider.userLoginLoading) {
                            final res = await provider.loginUser(
                                mobile: _userMobileCtr!.text.toString().trim(),
                                password: _userPassCtr!.text.toString().trim());
                            if (res) {
                              Navigator.pushReplacementNamed(
                                  context, Routes.mainHome);
                            }
                          }
                        } else {
                          bool isValid = validateOrgTextFields();
                          if (!isValid) return;
                          if (!provider.orgLoginLoading) {
                            final res = await provider.loginOrg(
                                mobile: _orgMobileCtr!.text.toString().trim(),
                                password: _orgPassCtr!.text.toString().trim());
                            if (res) {
                              Navigator.pushReplacementNamed(
                                  context, Routes.mainHomeOrg);
                            }
                          }
                        }
                      } catch (e) {
                        showToast("Something went wrong.!");
                      }
                    },
                    icon: (provider.orgLoginLoading && !isUserTab) ||
                            (provider.userLoginLoading && isUserTab)
                        ? SizedBox()
                        : Icon(Icons.login, color: Colors.white),
                    label: (provider.orgLoginLoading && !isUserTab) ||
                            (provider.userLoginLoading && isUserTab)
                        ? CircularProgressIndicator(color: Colors.white)
                        : Txt(
                            "Login",
                            textColor: Colors.white,
                          )),
              );
            }),
            Visibility(
              visible: !isUserTab,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Txt(
                      "Dont have an account?",
                      textColor: Colors.black,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.signup);
                        },
                        child: Txt(
                          "Sign Up",
                          textColor: AppColor.theme,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
