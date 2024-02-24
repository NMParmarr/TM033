import 'dart:io';

import 'package:eventflow/resources/routes/routes.dart';
import 'package:eventflow/utils/common_flushbar.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/viewmodels/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/datasource/services/connection/network_checker_widget.dart';
import '../../data/models/user_model.dart';
import '../../resources/helper/loader.dart';
import '../../utils/common_toast.dart';
import '../../utils/common_utils.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/constants/image_constants.dart';
import '../../utils/gap.dart';
import '../../utils/text.dart';
import '../../utils/widgets/custom_network_image.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../viewmodels/providers/media_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController? _userFullnameCtr;
  TextEditingController? _userEmailCtr;
  TextEditingController? _userMobileCtr;
  TextEditingController? _userFieldCtr;
  TextEditingController? _userAboutCtr;

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).setUserDOB(dob: DateTime.tryParse(widget.user.dob ?? ""), listen: false);
    initTextControllers();
    assignValuesToTextControllers();
    assignImage();
  }

  @override
  void dispose() {
    disposeTextControllers();
    super.dispose();
  }

  void initTextControllers() {
    _userFullnameCtr = TextEditingController();
    _userEmailCtr = TextEditingController();
    _userMobileCtr = TextEditingController();
    _userFieldCtr = TextEditingController();
    _userAboutCtr = TextEditingController();
  }

  void disposeTextControllers() {
    _userFullnameCtr?.dispose();
    _userEmailCtr?.dispose();
    _userMobileCtr?.dispose();
    _userFieldCtr?.dispose();
    _userAboutCtr?.dispose();
  }

  void clearTextControllers() {
    _userFullnameCtr?.clear();
    _userEmailCtr?.clear();
    _userMobileCtr?.clear();
    _userFieldCtr?.clear();
    _userAboutCtr?.clear();
  }

  void assignValuesToTextControllers() {
    _userFullnameCtr?.text = widget.user.name ?? "";
    _userEmailCtr?.text = widget.user.email ?? "";
    _userMobileCtr?.text = widget.user.mobile ?? "";
    _userFieldCtr?.text = widget.user.field ?? "";
    _userAboutCtr?.text = widget.user.about ?? "";
  }

  void assignImage() {
    Provider.of<MediaProvider>(context, listen: false).setImagePath(newPath: widget.user.image ?? "", listen: false);
  }

  bool validateUserTextFields() {
    if (_userFullnameCtr?.text.toString().trim() == "") {
      showToast("Enter full name");
      return false;
      //
    } else if (_userEmailCtr?.text.toString().trim() == "") {
      showToast("Enter email");
      return false;
      //
    } else if (!Utils.isValidEmail(email: _userEmailCtr!.text.toString().trim())) {
      showToast("Enter valid email");
      return false;
      //
    } else if (_userFieldCtr?.text.toString().trim() == "") {
      showToast("Enter Your Field");
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
                        child: Txt("Edit Profile", textColor: Colors.black, fontsize: 3.t, fontweight: FontWeight.bold),
                      ),
                      VGap(1.h),
                      Consumer<MediaProvider>(builder: (context, provider, _) {
                        return Center(
                          child: Hero(
                              tag: "userprofile",
                              child: (provider.imagePath.trim() == "")
                                  ? ClipOval(
                                      child: Container(
                                        height: 18.h,
                                        width: 18.h,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: AssetImage(Images.userPlaceholder), fit: BoxFit.cover)),
                                      ),
                                    )
                                  : provider.imagePath.startsWith('http')
                                      ? ClipOval(
                                          child: CustomNetworkImage(
                                            borderRadius: 15,
                                            height: 18.h,
                                            width: 18.h,
                                            url: provider.imagePath,
                                          ),
                                        )
                                      : ClipOval(
                                          child: Container(
                                            height: 18.h,
                                            width: 18.h,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: FileImage(File(provider.imagePath)), fit: BoxFit.fill)),
                                          ),
                                        )),
                        );
                      }),
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
                                    onPressed: () async {
                                      await Utils.showImagePickOptionDialog(context, aspectRatioPresets: [CropAspectRatioPreset.square], showSaveToast: true);
                                    },
                                    icon: Icon(Icons.edit, color: Colors.white),
                                    label: Txt("Change", textColor: Colors.white))),
                            HGap(2.w),
                            Expanded(
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.orange,
                                    ),
                                    onPressed: () {
                                      context.read<MediaProvider>().setImagePath(newPath: "");
                                    },
                                    icon: Icon(Icons.delete_outlined, color: Colors.white),
                                    label: Txt("Remove", textColor: Colors.white)))
                          ],
                        ),
                      ),
                      VGap(2.h),
                      Txt("Basic Information", textColor: Colors.black, fontsize: 3.t, fontweight: FontWeight.bold),
                      VGap(1.5.h),
                      Txt("Full Name", textColor: Colors.black, fontsize: 2.t, fontweight: FontWeight.w500),
                      CustomTextField(
                        ctr: _userFullnameCtr!,
                        hintText: "Enter full name",
                      ),
                      VGap(1.5.h),
                      Txt("Email", textColor: Colors.black, fontsize: 2.t, fontweight: FontWeight.w500),
                      CustomTextField(
                        ctr: _userEmailCtr!,
                        hintText: "Enter email",
                      ),
                      VGap(1.5.h),
                      Txt("Mobile", textColor: Colors.black, fontsize: 2.t, fontweight: FontWeight.w500),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          showToast("You can't change Mobile.!");
                        },
                        child: IgnorePointer(
                          child: CustomTextField(
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            readOnly: true,
                            ctr: _userMobileCtr!,
                            hintText: "Enter mobile ",
                          ),
                        ),
                      ),
                      VGap(1.5.h),
                      Txt("Birth Date", textColor: Colors.black, fontsize: 2.t, fontweight: FontWeight.w500),
                      Consumer<ProfileProvider>(builder: (context, provider, _) {
                        return InkWell(
                          onTap: () async {
                            DateTime? dob = await showDatePicker(context: context, firstDate: DateTime(1980), lastDate: DateTime.now());
                            provider.setUserDOB(dob: dob);
                          },
                          child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.3.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.withOpacity(0.25),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [Txt(provider.dob != null ? DateFormat('dd-MM-yyyy').format(provider.dob!) : "Select Birth Date"), Icon(Icons.date_range_outlined)],
                              )),
                        );
                      }),
                      VGap(1.5.h),
                      Txt("Field", textColor: Colors.black, fontsize: 2.t, fontweight: FontWeight.w500),
                      CustomTextField(
                        ctr: _userFieldCtr!,
                        hintText: "Enter your field",
                      ),
                      VGap(1.5.h),
                      Txt("About", textColor: Colors.black, fontsize: 2.t, fontweight: FontWeight.w500),
                      CustomTextField(ctr: _userAboutCtr!, lines: 5, hintText: "Enter description about yourself.."),
                      VGap(3.h),
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 155, 155, 155),
                                  ),
                                  onPressed: () {},
                                  icon: Icon(Icons.close, color: Colors.white),
                                  label: Txt("Discard", textColor: Colors.white))),
                          HGap(2.w),
                          Expanded(child: Consumer<ProfileProvider>(builder: (context, provider, _) {
                            return ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.theme,
                                ),
                                onPressed: () async {
                                  bool isValid = validateUserTextFields();
                                  if (!isValid) return;
                                  showLoader(context);
                                  String imageUrl = "";
                                  if (context.read<MediaProvider>().imagePath.toString().trim() != "") {
                                    if (context.read<MediaProvider>().imagePath.startsWith("http")) {
                                      imageUrl = context.read<MediaProvider>().imagePath;
                                    } else {
                                      imageUrl = await context.read<MediaProvider>().uploadImage(imagePath: context.read<MediaProvider>().imagePath.toString().trim());
                                    }
                                  }
                                  bool res = await provider.updateUserDetails(updatedJsonData: {
                                    "fullName": _userFullnameCtr?.text.toString().trim(),
                                    "email": _userEmailCtr?.text.toString().trim(),
                                    "dob": provider.dob.toString(),
                                    "field": _userFieldCtr?.text.toString().trim(),
                                    "about": _userAboutCtr?.text.toString().trim(),
                                    "image": imageUrl,
                                    "isProfileCompleted": true,
                                  });
                                  hideLoader();
                                  if (res) {
                                    Navigator.pop(context);
                                    showFlushbar(context, "Saved successfully..!");
                                    provider.clearUserDOB();
                                  }
                                },
                                icon: Icon(Icons.check_circle, color: Colors.white),
                                label: Txt("Save", textColor: Colors.white));
                          })),
                        ],
                      ),
                      VGap(3.h),
                      ListTile(
                        onTap: () {
                          Navigator.popAndPushNamed(context, Routes.changePassword, arguments: {'isUser': true});
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
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.w),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios_new_rounded),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: CircleBorder()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
