import 'package:eventflow/utils/common_flushbar.dart';
import 'package:eventflow/utils/common_toast.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/viewmodels/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/common_utils.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/gap.dart';
import '../../utils/text.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../viewmodels/providers/auth_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  final bool isUser;
  const ChangePasswordScreen({super.key, required this.isUser});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController? _currentPassCtr;
  TextEditingController? _newPassCtr;
  TextEditingController? _newCPassCtr;

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
    _currentPassCtr = TextEditingController();
    _newPassCtr = TextEditingController();
    _newCPassCtr = TextEditingController();
  }

  void disposeTextControllers() {
    _currentPassCtr?.dispose();
    _newPassCtr?.dispose();
    _newCPassCtr?.dispose();
  }

  void clearTextControllers() {
    _currentPassCtr?.clear();
    _newPassCtr?.clear();
    _newCPassCtr?.clear();
  }

  bool validatePasswordFields() {
    if (_currentPassCtr?.text.toString().trim() == "") {
      showToast("Enter Current Password");
      return false;
      //
    } else if (_newPassCtr?.text.toString().trim() == "") {
      showToast("Enter New Password");
      return false;
      //
    } else if (!Utils.isValidLengthPassword(
        password: _newPassCtr!.text.toString().trim())) {
      showToast("Password must be atleast 8 char long");
      return false;
      //
    } else if (_newCPassCtr?.text.toString().trim() == "") {
      showToast("Enter Confirm Password");
      return false;
      //
    } else if (_newCPassCtr?.text.toString().trim() !=
        _newCPassCtr?.text.toString().trim()) {
      showToast("Password Mismatched..");
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
                          ctr: _currentPassCtr!,
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
                          ctr: _newPassCtr!,
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
                          ctr: _newCPassCtr!,
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
                        Expanded(child: Consumer<ProfileProvider>(
                            builder: (context, provider, _) {
                          return ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.theme,
                              ),
                              onPressed: () async {
                                bool isValid = validatePasswordFields();
                                if (!isValid) return;
                                final bool res = await provider.changePassword(
                                    currentPass:
                                        _currentPassCtr!.text.toString().trim(),
                                    newPass:
                                        _newPassCtr!.text.toString().trim(),
                                    isUser: true);

                                if (res) {
                                  Navigator.pop(context);
                                  showFlushbar(context,
                                      "Password changed successfully..!");
                                }
                              },
                              icon: provider.saveLoading
                                  ? SizedBox()
                                  : Icon(Icons.check_circle,
                                      color: Colors.white),
                              label: provider.saveLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white)
                                  : Txt("Save", textColor: Colors.white));
                        })),
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
