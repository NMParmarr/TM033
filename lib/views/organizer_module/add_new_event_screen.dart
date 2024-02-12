import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:eventflow/utils/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEventScren extends StatefulWidget {
  const AddEventScren({super.key});

  @override
  State<AddEventScren> createState() => _AddEventScrenState();
}

class _AddEventScrenState extends State<AddEventScren> {
  DateTime? eventDate;
  TimeOfDay? eventTime;
  String formattedTimeOfDay = '';

  // String? selectedValueSingleDialogEditableItems;
  // List<DropdownMenuItem> editableItems = List.generate(
  //     7,
  //     (index) =>
  //         DropdownMenuItem(child: Txt("value $index"), value: "value $index"));

  addItemDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext alertContext) {
        Widget dialogWidget = AlertDialog(
          title: Txt("Add an item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CustomTextField(
                  ctr: TextEditingController(), hintText: "Enter new type"),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(alertContext, null);
                      },
                      child: Txt("Cancel"),
                    ),
                  ),
                  HGap(2),
                  Expanded(
                    child: TextButton(
                      onPressed: () {                        
                        Navigator.pop(alertContext, "new items");
                      },
                      child: Txt("Ok"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

        return (dialogWidget);
      },
    );
  }

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
                      child: Txt("Add New Event",
                          textColor: Colors.black,
                          fontsize: 3.t,
                          fontweight: FontWeight.bold),
                    ),
                    VGap(1.h),
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.3.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.25),
                            image: 1 == 1
                                ? null
                                : DecorationImage(
                                    image: AssetImage(Images.imagePlaceholder),
                                    fit: BoxFit.cover)),
                        child: Visibility(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 20.w,
                              color: AppColor.secondaryTxt,
                            ),
                            Txt(
                              "Tap to add an image",
                              fontsize: 3.t,
                              textColor: AppColor.secondaryTxt,
                            ),
                          ],
                        )),
                      ),
                    ),
                    VGap(2.h),
                    Txt("Event Name",
                        textColor: Colors.black,
                        fontsize: 2.t,
                        fontweight: FontWeight.w500),
                    CustomTextField(
                        ctr: TextEditingController(),
                        hintText: "Enter an event name"),
                    VGap(1.5.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Txt("Date",
                                  textColor: Colors.black,
                                  fontsize: 2.t,
                                  fontweight: FontWeight.w500),
                              InkWell(
                                onTap: () async {
                                  eventDate = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2026));
                                  setState(() {});
                                },
                                child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 3.w, vertical: 1.3.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.withOpacity(0.25),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Txt(eventDate != null
                                              ? DateFormat('dd-MM-yyyy')
                                                  .format(eventDate!)
                                              : "Choose Date"),
                                        ),
                                        Icon(Icons.date_range_outlined)
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                        HGap(3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Txt("Time",
                                  textColor: Colors.black,
                                  fontsize: 2.t,
                                  fontweight: FontWeight.w500),
                              InkWell(
                                onTap: () async {
                                  eventTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now());
                                  final localizations =
                                      MaterialLocalizations.of(context);
                                  formattedTimeOfDay =
                                      localizations.formatTimeOfDay(eventTime!);
                                  setState(() {});
                                },
                                child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 3.w, vertical: 1.3.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.withOpacity(0.25),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Txt(eventTime != null
                                              ? formattedTimeOfDay
                                              : "Choose Time"),
                                        ),
                                        Icon(Icons.watch_later_outlined)
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    VGap(1.5.h),
                    Txt("Location",
                        textColor: Colors.black,
                        fontsize: 2.t,
                        fontweight: FontWeight.w500),
                    CustomTextField(
                        ctr: TextEditingController(),
                        hintText: "Enter a location"),
                    VGap(1.5.h),
                    Txt("Type",
                        textColor: Colors.black,
                        fontsize: 2.t,
                        fontweight: FontWeight.w500),

                    ///
                    /// type search field
                    ///
                    InkWell(
                        onTap: () {
                          print(" --- show dialog");
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                  title: Txt("Select Type"),
                                  scrollable: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          addItemDialog();
                                        },
                                        child: Txt("Add New Type"))
                                  ],
                                  actionsAlignment: MainAxisAlignment.center,
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                        5,
                                        (index) => SimpleDialogOption(
                                              onPressed: () {
                                                print(" --- value $index");
                                                Navigator.pop(context);
                                              },
                                              child: Txt("Type $index"),
                                            )),
                                  )));
                        },
                        borderRadius: BorderRadius.circular(10),
                        overlayColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.transparent),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 6.h,
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.3.h),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.25),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Txt(
                                "Select one",
                                fontsize: 2.t,
                              ),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                        )),
                    // Builder(builder: (context) {
                    //   return Container(
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       color: Colors.grey.withOpacity(0.25),
                    //     ),
                    //     child: SearchChoices.single(
                    //       // validator: (_) => null,
                    //       // fieldDecoration: BoxDecoration(),
                    //       underline: "",
                    //       padding: EdgeInsets.symmetric(
                    //         horizontal: 3.w,
                    //       ),
                    //       items: editableItems,
                    //       value: selectedValueSingleDialogEditableItems,
                    //       hint: "Select one",
                    //       searchHint: "Select one",
                    //       autofocus: false,
                    //       displayClearIcon: false,
                    //       disabledHint: (Function updateParent) {
                    //         return (TextButton(
                    //           onPressed: () {
                    //             addItemDialog().then((value) async {
                    //               updateParent(value);
                    //             });
                    //           },
                    //           child: Txt("No choice, click to add one"),
                    //         ));
                    //       },
                    //       closeButton: (String? value,
                    //           BuildContext closeContext,
                    //           Function updateParent) {
                    //         return (editableItems.length >= 100
                    //             ? "Close"
                    //             : TextButton(
                    //                 onPressed: () {
                    //                   addItemDialog().then((value) async {
                    //                     if (value != null &&
                    //                         editableItems.indexWhere(
                    //                                 (element) =>
                    //                                     element.value ==
                    //                                     value) !=
                    //                             -1) {
                    //                       Navigator.pop(context);
                    //                       updateParent(value);
                    //                     }
                    //                   });
                    //                 },
                    //                 child: const Text("Add and select item"),
                    //               ));
                    //       },
                    //       onChanged: (String? value) {
                    //         setState(() {
                    //           if (value is! NotGiven) {
                    //             selectedValueSingleDialogEditableItems = value;
                    //           } else {
                    //             showToast(" --- hello else part : $value");
                    //           }
                    //         });
                    //       },
                    //       displayItem: (item, selected, Function updateParent) {
                    //         return (Row(children: [
                    //           selected
                    //               ? const Icon(
                    //                   Icons.check,
                    //                   color: AppColor.theme,
                    //                 )
                    //               : const Icon(
                    //                   Icons.check_box_outline_blank,
                    //                   color: Colors.transparent,
                    //                 ),
                    //           const SizedBox(width: 7),
                    //           Expanded(
                    //             child: item,
                    //           ),
                    //           HGap(7),
                    //           // IconButton(
                    //           //   icon: const Icon(
                    //           //     Icons.delete,
                    //           //     color: Colors.red,
                    //           //   ),
                    //           //   onPressed: () {
                    //           //     editableItems
                    //           //         .removeWhere((element) => item == element);
                    //           //     updateParent(null);
                    //           //     setState(() {});
                    //           //   },
                    //           // ),
                    //         ]));
                    //       },
                    //       dialogBox: true,
                    //       isExpanded: true,
                    //       doneButton: "Done",
                    //     ),
                    //   );
                    // }),

                    ///
                    ///
                    ///
                    VGap(1.5.h),
                    Txt("Description",
                        textColor: Colors.black,
                        fontsize: 2.t,
                        fontweight: FontWeight.w500),
                    CustomTextField(
                        ctr: TextEditingController(),
                        hintText: "Enter a description",
                        lines: 5),
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
