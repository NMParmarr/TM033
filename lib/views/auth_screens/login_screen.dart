import 'package:eventflow/resources/routes/routes.dart';
import 'package:eventflow/utils/common_toast.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/widgets/custom_text_field.dart';
import 'package:eventflow/viewmodels/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/color_constants.dart';
import '../../utils/text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

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
    List clgList = [
      "Select College",
      "Geetanjali College",
      "Harivandana College",
      "Grace College",
      "Christ College"
    ];
    return Padding(
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
            ctr: TextEditingController(),
            hintText: "Enter mobile",
          ),
          VGap(1.h),
          Txt("Password",
              textColor: Colors.black,
              fontsize: 2.t,
              fontweight: FontWeight.w500),
          Consumer<AuthProvider>(builder: (context, provider, _) {
            return CustomTextField(
                ctr: TextEditingController(),
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(color: Colors.grey.shade200),
            width: double.infinity,
            child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    value: clgList[0],
                    items: List.generate(
                        clgList.length,
                        (index) => DropdownMenuItem(
                            value: clgList[index], child: Txt(clgList[index]))),
                    onChanged: (_) {})),
          ),
          VGap(3.h),
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
                    isUserTab
                        ? Navigator.pushNamed(context, Routes.mainHome)
                        : Navigator.pushNamed(context, Routes.mainHomeOrg);
                  }
                },
                icon: Icon(Icons.login, color: Colors.white),
                label: Txt(
                  "Login",
                  textColor: Colors.white,
                )),
          ),
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
    );
  }
}
