import 'package:eventflow/resources/routes/routes.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/constants/color_constants.dart';
import '../../utils/constants/image_constants.dart';
import '../../utils/gap.dart';
import '../../utils/text.dart';
import '../../utils/widgets/custom_text_field.dart';

class EditOrgProfileScreen extends StatefulWidget {
  const EditOrgProfileScreen({super.key});

  @override
  State<EditOrgProfileScreen> createState() => _EditOrgProfileScreenState();
}

class _EditOrgProfileScreenState extends State<EditOrgProfileScreen> {
  DateTime? dob;

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
                      child: Txt("Edit Profile",
                          textColor: Colors.black,
                          fontsize: 3.t,
                          fontweight: FontWeight.bold),
                    ),
                    VGap(1.h),
                    Center(
                      child: Hero(
                        tag: "orgprofile",
                        child: CircleAvatar(
                          radius: 14.w,
                          backgroundImage: AssetImage(Images.sampleImage),
                        ),
                      ),
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
                                  label:
                                      Txt("Change", textColor: Colors.white))),
                          HGap(2.w),
                          Expanded(
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.orange,
                                  ),
                                  onPressed: () {},
                                  icon: Icon(Icons.delete_outlined,
                                      color: Colors.white),
                                  label:
                                      Txt("Remove", textColor: Colors.white)))
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
                      ctr: TextEditingController(),
                      hintText: "Enter organization name",
                    ),
                    VGap(1.5.h),
                    Txt("Organizer Name",
                        textColor: Colors.black,
                        fontsize: 2.t,
                        fontweight: FontWeight.w500),
                    CustomTextField(
                      ctr: TextEditingController(),
                      hintText: "Enter organizer name",
                    ),
                    VGap(1.5.h),
                    Txt("Email",
                        textColor: Colors.black,
                        fontsize: 2.t,
                        fontweight: FontWeight.w500),
                    CustomTextField(
                        ctr: TextEditingController(),
                        hintText: "Enter organizer's email"),
                    VGap(1.5.h),
                    Txt("Mobile",
                        textColor: Colors.black,
                        fontsize: 2.t,
                        fontweight: FontWeight.w500),
                    CustomTextField(
                        ctr: TextEditingController(),
                        hintText: "Enter organizer's mobile",
                        readOnly: true),
                    VGap(1.5.h),
                    // Txt("Birth Date",
                    //     textColor: Colors.black,
                    //     fontsize: 2.t,
                    //     fontweight: FontWeight.w500),
                    // InkWell(
                    //   onTap: () async {
                    //     dob = await showDatePicker(
                    //         context: context,
                    //         firstDate: DateTime(1980),
                    //         lastDate: DateTime.now());
                    //     setState(() {});
                    //   },
                    //   child: Container(
                    //       width: double.infinity,
                    //       padding: EdgeInsets.symmetric(
                    //           horizontal: 3.w, vertical: 1.3.h),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: Colors.grey.withOpacity(0.25),
                    //       ),
                    //       child: Txt(dob != null
                    //           ? DateFormat('dd-MM-yyyy').format(dob!)
                    //           : "Choose DOB")),
                    // ),
                    // VGap(1.5.h),
                    // Txt("Field",
                    //     textColor: Colors.black,
                    //     fontsize: 2.t,
                    //     fontweight: FontWeight.w500),
                    // CustomTextField(ctr: TextEditingController()),
                    VGap(1.5.h),
                    Txt("About",
                        textColor: Colors.black,
                        fontsize: 2.t,
                        fontweight: FontWeight.w500),
                    CustomTextField(
                      ctr: TextEditingController(),
                      lines: 5,
                      hintText: "Enter description of organization",
                    ),
                    VGap(3.h),
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
                    VGap(3.h),
                    ListTile(
                      onTap: () {
                        Navigator.popAndPushNamed(
                            context, Routes.changePassword);
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
