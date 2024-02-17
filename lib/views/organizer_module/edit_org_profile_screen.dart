import 'dart:io';

import 'package:eventflow/data/datasource/services/firebase_services.dart';
import 'package:eventflow/data/models/organizer_model.dart';
import 'package:eventflow/resources/routes/routes.dart';
import 'package:eventflow/utils/common_flushbar.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/viewmodels/providers/home_provider.dart';
import 'package:eventflow/viewmodels/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../utils/common_toast.dart';
import '../../utils/common_utils.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/constants/image_constants.dart';
import '../../utils/gap.dart';
import '../../utils/text.dart';
import '../../utils/widgets/custom_text_field.dart';

class EditOrgProfileScreen extends StatefulWidget {
  final OrganizerModel org;
  const EditOrgProfileScreen({super.key, required this.org});

  @override
  State<EditOrgProfileScreen> createState() => _EditOrgProfileScreenState();
}

class _EditOrgProfileScreenState extends State<EditOrgProfileScreen> {
  DateTime? dob;
  TextEditingController? _orgTionCtr;
  TextEditingController? _orgZerCtr;
  TextEditingController? _orgEmailCtr;
  TextEditingController? _orgMobileCtr;
  TextEditingController? _orgAboutCtr;

  @override
  void initState() {
    super.initState();
    initTextControllers();
    assignValuesToTextControllers();
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
    _orgAboutCtr = TextEditingController();
  }

  void disposeTextControllers() {
    _orgTionCtr?.dispose();
    _orgZerCtr?.dispose();
    _orgEmailCtr?.dispose();
    _orgMobileCtr?.dispose();
    _orgAboutCtr?.dispose();
  }

  void clearTextControllers() {
    _orgTionCtr?.clear();
    _orgZerCtr?.clear();
    _orgEmailCtr?.clear();
    _orgMobileCtr?.clear();
    _orgAboutCtr?.clear();
  }

  void assignValuesToTextControllers() {
    _orgTionCtr?.text = widget.org.organization ?? "--";
    _orgZerCtr?.text = widget.org.organizer ?? "--";
    _orgEmailCtr?.text = widget.org.email ?? "--";
    _orgMobileCtr?.text = widget.org.mobile ?? "--";
    _orgAboutCtr?.text = widget.org.about ?? "--";
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
            RefreshIndicator(
              onRefresh: () async {
                setState(() {});
                return Future.delayed(Duration(milliseconds: 700));
              },
              child: SingleChildScrollView(
                  child: _contentWidget(context, org: widget.org)),
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

  Padding _contentWidget(BuildContext context, {required OrganizerModel? org}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VGap(1.5.h),
          Center(
            child: Txt("Edit Profile",
                textColor: Colors.black,
                fontsize: 3.t,
                fontweight: FontWeight.bold),
          ),
          VGap(1.h),
          Center(
            child: Hero(
                tag: "orgprofile",
                child: (org != null && org.image != null && org.image != "")
                    ? (org.image!.startsWith('http'))
                        ? CircleAvatar(
                            radius: 14.w,
                            backgroundImage: NetworkImage(org.image!),
                          )
                        : CircleAvatar(
                            radius: 14.w,
                            backgroundImage: FileImage(File("/data/path")),
                          )
                    : CircleAvatar(
                        radius: 14.w,
                        backgroundImage: AssetImage(Images.imagePlaceholder),
                      )),
          ),
          VGap(2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.edit, color: Colors.white),
                        label: Txt("Change", textColor: Colors.white))),
                HGap(2.w),
                Expanded(
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.orange,
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.delete_outlined, color: Colors.white),
                        label: Txt("Remove", textColor: Colors.white)))
              ],
            ),
          ),
          VGap(2.h),
          Txt("Basic Information",
              textColor: Colors.black,
              fontsize: 3.t,
              fontweight: FontWeight.bold),
          VGap(1.5.h),
          Txt("Organization Name",
              textColor: Colors.black,
              fontsize: 2.t,
              fontweight: FontWeight.w500),
          CustomTextField(
            ctr: _orgTionCtr!,
            hintText: "Enter organization name",
            capitalization: TextCapitalization.words,
          ),
          VGap(1.5.h),
          Txt("Organizer Name",
              textColor: Colors.black,
              fontsize: 2.t,
              fontweight: FontWeight.w500),
          CustomTextField(
            ctr: _orgZerCtr!,
            hintText: "Enter organizer name",
            capitalization: TextCapitalization.words,
          ),
          VGap(1.5.h),
          Txt("Email",
              textColor: Colors.black,
              fontsize: 2.t,
              fontweight: FontWeight.w500),
          CustomTextField(
              ctr: _orgEmailCtr!, hintText: "Enter organizer's email"),
          VGap(1.5.h),
          Txt("Mobile",
              textColor: Colors.black,
              fontsize: 2.t,
              fontweight: FontWeight.w500),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              showToast("You can't change Mobile.!");
            },
            child: IgnorePointer(
              child: CustomTextField(
                  ctr: _orgMobileCtr!,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  inputType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  hintText: "Enter organizer's mobile",
                  readOnly: true),
            ),
          ),
          VGap(1.5.h),
          Txt("About",
              textColor: Colors.black,
              fontsize: 2.t,
              fontweight: FontWeight.w500),
          CustomTextField(
            ctr: _orgAboutCtr!,
            lines: 5,
            hintText: "Enter description of organization",
          ),
          VGap(3.h),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 155, 155, 155),
                      ),
                      onPressed: () {
                        clearTextControllers();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close, color: Colors.white),
                      label: Txt("Discard", textColor: Colors.white))),
              HGap(2.w),
              Expanded(child:
                  Consumer<ProfileProvider>(builder: (context, provider, _) {
                return ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.theme,
                    ),
                    onPressed: () async {
                      bool isValid = validateOrgTextFields();
                      if (!isValid) return;

                      if (!provider.saveLoading) {
                        bool res =
                            await provider.updateOrgDetails(updatedJsonData: {
                          "organization": _orgTionCtr?.text.toString().trim(),
                          "organizer": _orgZerCtr?.text.toString().trim(),
                          "email": _orgEmailCtr?.text
                              .toString()
                              .trim()
                              .toLowerCase(),
                          "about": _orgAboutCtr?.text.toString().trim(),
                          "image": provider.imagePath,
                        });
                        if (res) {
                          Navigator.pop(context);
                          showFlushbar(context, "Saved successfully..!");
                        }
                      }
                    },
                    icon: provider.saveLoading
                        ? SizedBox()
                        : Icon(Icons.check_circle, color: Colors.white),
                    label: provider.saveLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Txt("Save", textColor: Colors.white));
              })),
            ],
          ),
          VGap(3.h),
          ListTile(
            onTap: () {
              Navigator.popAndPushNamed(context, Routes.changePassword,
                  arguments: {'isUser': false});
            },
            leading: Icon(
              Icons.lock,
              color: AppColor.theme,
            ),
            title: Txt(
              "Change Password",
              textColor: AppColor.theme,
            ),
          ),
          VGap(3.h),
        ],
      ),
    );
  }
}
