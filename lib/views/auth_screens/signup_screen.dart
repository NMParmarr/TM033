import 'package:eventflow/data/datasource/services/firebase/firebase_services.dart';
import 'package:eventflow/data/models/organizer_model.dart';
import 'package:eventflow/utils/common_utils.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:eventflow/viewmodels/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/datasource/services/connection/network_checker_widget.dart';
import '../../utils/common_toast.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController? _orgTionCtr;
  TextEditingController? _orgZerCtr;
  TextEditingController? _orgEmailCtr;
  TextEditingController? _orgMobileCtr;
  TextEditingController? _orgPassCtr;
  TextEditingController? _orgCpassCtr;

  final _formKey = GlobalKey<FormState>();

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
    _orgTionCtr = TextEditingController();
    _orgZerCtr = TextEditingController();
    _orgEmailCtr = TextEditingController();
    _orgMobileCtr = TextEditingController();
    _orgPassCtr = TextEditingController();
    _orgCpassCtr = TextEditingController();
  }

  void disposeTextControllers() {
    _orgTionCtr?.dispose();
    _orgZerCtr?.dispose();
    _orgEmailCtr?.dispose();
    _orgMobileCtr?.dispose();
    _orgPassCtr?.dispose();
    _orgCpassCtr?.dispose();
  }

  void clearTextControllers() {
    _orgTionCtr?.clear();
    _orgZerCtr?.clear();
    _orgEmailCtr?.clear();
    _orgMobileCtr?.clear();
    _orgPassCtr?.clear();
    _orgCpassCtr?.clear();
  }

  bool validateOrgTextFields() {
    if (_orgTionCtr?.text.toString().trim() == "") {
      showToast("Enter organization name");
      return false;
      //
    } else if (_orgZerCtr?.text.toString().trim() == "") {
      showToast("Enter Organizer name");
      return false;
      //
    } else if (_orgEmailCtr?.text.toString().trim() == "") {
      showToast("Enter Email");
      return false;
      //
    } else if (!Utils.isValidEmail(
        email: _orgEmailCtr!.text.toString().trim())) {
      showToast("Enter valid email");
      return false;
      //
    } else if (_orgMobileCtr?.text.toString().trim() == "") {
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
    } else if (_orgCpassCtr?.text.toString().trim() == "") {
      showToast("Enter Confirm Password");
      return false;
      //
    } else if (_orgPassCtr?.text.toString().trim() !=
        _orgCpassCtr?.text.toString().trim()) {
      showToast("Password Mismatched..");
      return false;
      //
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NetworkCheckerWidget(
      child: Scaffold(
        backgroundColor: AppColor.theme,
        appBar: PreferredSize(
          preferredSize: Size(100.w, 15.h),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 2.h),
                    alignment: Alignment.center,
                    height: 10.h,
                    child: Hero(
                        tag: "AppLogo",
                        child: Image.asset(Images.applogoWithoutBg))),
                Txt(
                  "Event Flow",
                  fontsize: 4.t,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Form(
              key: _formKey,
              child: Container(
                height: 85.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white),
                child: SingleChildScrollView(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VGap(2.h),
                      Center(
                        child: Txt("Register Organizer",
                            textColor: Colors.black,
                            fontsize: 3.t,
                            fontweight: FontWeight.bold),
                      ),
                      VGap(2.h),
                      Txt("Organization Name",
                          textColor: Colors.black,
                          fontsize: 2.t,
                          fontweight: FontWeight.w500),
                      CustomTextField(
                        ctr: _orgTionCtr!,
                        capitalization: TextCapitalization.words,
                        hintText: "Enter organization name",
                      ),
                      VGap(2.h),
                      Txt("Organizer Name",
                          textColor: Colors.black,
                          fontsize: 2.t,
                          fontweight: FontWeight.w500),
                      CustomTextField(
                        ctr: _orgZerCtr!,
                        capitalization: TextCapitalization.words,
                        hintText: "Enter organizer name",
                      ),
                      VGap(2.h),
                      Txt("Email",
                          textColor: Colors.black,
                          fontsize: 2.t,
                          fontweight: FontWeight.w500),
                      CustomTextField(
                        ctr: _orgEmailCtr!,
                        hintText: "Enter organizer's email",
                      ),
                      VGap(2.h),
                      Txt("Mobile",
                          textColor: Colors.black,
                          fontsize: 2.t,
                          fontweight: FontWeight.w500),
                      CustomTextField(
                        ctr: _orgMobileCtr!,
                        hintText: "Enter organizer's mobile",
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      
                        inputType: TextInputType.numberWithOptions(
                            decimal: false, signed: false),
                        maxLength: 10,
                      ),
                      VGap(2.h),
                      Txt("Password",
                          textColor: Colors.black,
                          fontsize: 2.t,
                          fontweight: FontWeight.w500),
                      Consumer<AuthProvider>(builder: (context, provider, _) {
                        return CustomTextField(
                            ctr: _orgPassCtr!,
                            obsecuredText: !provider.isOrgPassVisible,
                            hintText: "Atleast 8 characters",
                            suffixIcon: IconButton(
                              icon: provider.isOrgPassVisible
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                              onPressed: () {
                                provider.toggleOrgPass();
                              },
                            ));
                      }),
                      VGap(2.h),
                      Txt("Confirm Password",
                          textColor: Colors.black,
                          fontsize: 2.t,
                          fontweight: FontWeight.w500),
                      Consumer<AuthProvider>(builder: (context, provider, _) {
                        return CustomTextField(
                            ctr: _orgCpassCtr!,
                            obsecuredText: !provider.isOrgCPassVisible,
                            hintText: "Re-enter same password",
                            suffixIcon: IconButton(
                              icon: provider.isOrgCPassVisible
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                              onPressed: () {
                                provider.toggleOrgCPass();
                              },
                            ));
                      }),
                      VGap(2.h),
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
                                bool isValid = validateOrgTextFields();
                                if (!isValid) return;
                                if (!provider.signupLoading) {
                                  final orgId =
                                      FireServices.instance.organizers.doc().id;
                                  final orgModel = OrganizerModel(
                                    id: orgId,
                                    organization:
                                        _orgTionCtr?.text.toString().trim(),
                                    organizer: _orgZerCtr?.text.toString().trim(),
                                    email: _orgEmailCtr?.text
                                        .toString()
                                        .trim()
                                        .toLowerCase(),
                                    mobile: _orgMobileCtr?.text.toString().trim(),
                                    password: _orgPassCtr?.text.toString().trim(),
                                    joinDate: "${DateTime.now()}",
                                  );
                                  final res = await provider.signUpOrganizer(
                                      id: orgId, orgModel: orgModel);
                                  if (res) {
                                    await showToast("Registered Successfully..!");
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              icon: provider.signupLoading
                                  ? SizedBox()
                                  : Icon(Icons.login, color: Colors.white),
                              label: provider.signupLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Txt(
                                      "Register",
                                      textColor: Colors.white,
                                    )),
                        );
                      }),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Txt(
                              "Already have an account?",
                              textColor: Colors.black,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Txt(
                                  "Login",
                                  textColor: AppColor.theme,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              )),
        ),
      ),
    );
  }
}
