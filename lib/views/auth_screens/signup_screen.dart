import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:eventflow/viewmodels/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../utils/common_toast.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    CustomTextField(ctr: TextEditingController()),
                    VGap(2.h),
                    Txt("Email",
                        textColor: Colors.black,
                        fontsize: 2.t,
                        fontweight: FontWeight.w500),
                    CustomTextField(ctr: TextEditingController()),
                    VGap(2.h),
                    Txt("Mobile",
                        textColor: Colors.black,
                        fontsize: 2.t,
                        fontweight: FontWeight.w500),
                    CustomTextField(ctr: TextEditingController()),
                    VGap(2.h),
                    Txt("Password",
                        textColor: Colors.black,
                        fontsize: 2.t,
                        fontweight: FontWeight.w500),
                    Consumer<AuthProvider>(builder: (context, provider, _) {
                      return CustomTextField(
                          ctr: TextEditingController(),
                          obsecuredText: !provider.isOrgPassVisible,
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
                          ctr: TextEditingController(),
                          obsecuredText: !provider.isOrgCPassVisible,
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
                    Container(
                      width: 100.w,
                      height: 6.h,
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.theme,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              showToast("Entered to login");
                            }
                          },
                          icon: Icon(Icons.login, color: Colors.white),
                          label: Txt(
                            "Register",
                            textColor: Colors.white,
                          )),
                    ),
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
    );
  }
}
