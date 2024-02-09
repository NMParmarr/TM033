import 'package:eventflow/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/routes/routes.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/gap.dart';
import '../../utils/text.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../viewmodels/providers/auth_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Color.fromARGB(255, 240, 240, 240),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VGap(1.5.h),
                    Center(
                      child: Txt("Change Password",
                          textColor: Colors.black,
                          fontsize: 3.t,
                          fontweight: FontWeight.bold),
                    ),
                    VGap(2.h),
                    Txt("Current Password",
                        textColor: Colors.black,
                        fontsize: 2.t,
                        fontweight: FontWeight.w500),
                    Consumer<AuthProvider>(builder: (context, provider, _) {
                      return CustomTextField(
                          ctr: TextEditingController(),
                          obsecuredText: !provider.isUserPassVisible,
                          suffixIcon: IconButton(
                            icon: provider.isUserPassVisible
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              provider.toggleUserPass();
                            },
                          ));
                    }),
                    VGap(2.h),
                    Txt("Enter New Password",
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
                    Txt("Confirm New Password",
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
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 155, 155, 155),
                                ),
                                onPressed: () {},
                                icon: Icon(Icons.close, color: Colors.white),
                                label:
                                    Txt("Discard", textColor: Colors.white))),
                        HGap(2.w),
                        Expanded(
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.theme,
                                ),
                                onPressed: () {},
                                icon: Icon(Icons.check_circle,
                                    color: Colors.white),
                                label: Txt("Save", textColor: Colors.white))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.w),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios_new_rounded),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, shape: CircleBorder()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
