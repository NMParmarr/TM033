import 'dart:io';

import 'package:eventflow/data/datasource/services/firebase/firebase_services.dart';
import 'package:eventflow/data/models/event_type.dart';
import 'package:eventflow/globles.dart';
import 'package:eventflow/resources/helper/loader.dart';
import 'package:eventflow/resources/helper/shared_preferences.dart';
import 'package:eventflow/utils/common_flushbar.dart';
import 'package:eventflow/utils/common_toast.dart';
import 'package:eventflow/utils/common_utils.dart';
import 'package:eventflow/utils/constants/app_constants.dart';
import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/constants/string_constants.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:eventflow/utils/widgets/custom_text_field.dart';
import 'package:eventflow/viewmodels/providers/home_provider.dart';
import 'package:eventflow/viewmodels/providers/media_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/datasource/services/connection/network_checker_widget.dart';
import '../../data/models/event_model.dart';

class AddEventScren extends StatefulWidget {
  final EventModel? updateEvent;
  const AddEventScren({super.key, this.updateEvent});

  @override
  State<AddEventScren> createState() => _AddEventScrenState();
}

class _AddEventScrenState extends State<AddEventScren> {
  String formattedTimeOfDay = '';
  String formattedDate = '';

  TextEditingController? _eventNameCtr;
  TextEditingController? _locationCtr;
  TextEditingController? _descCtr;

  @override
  void initState() {
    super.initState();
    initTextControllers();
    initHomeProvider();
    assignValues();
  }

  @override
  void dispose() {
    disposeTextControllers();
    super.dispose();
  }

  void initHomeProvider() {
    Provider.of<HomeProvider>(context, listen: false)
        .setSelectedType(newType: Strings.selectType, listen: false);
    Provider.of<HomeProvider>(context, listen: false)
        .setEventDate(date: null, listen: false);
    Provider.of<HomeProvider>(context, listen: false)
        .setEventTime(time: null, listen: false);
    Provider.of<MediaProvider>(context, listen: false)
        .setImagePath(newPath: "", listen: false);
  }

  void initTextControllers() {
    _eventNameCtr = TextEditingController();
    _locationCtr = TextEditingController();
    _descCtr = TextEditingController();
  }

  void assignValues() {
    if (widget.updateEvent != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final eventType = await FireServices.instance.getEventTypeByTypeId(
            orgId: widget.updateEvent!.orgId!,
            typeId: widget.updateEvent!.typeId!);
        Provider.of<HomeProvider>(context, listen: false)
            .setSelectedType(newType: eventType.name ?? Strings.selectType);
      });
      // DateFormat format = DateFormat('dd-MM-yyyy');
      DateTime? date = widget.updateEvent?.eventDate == null
          ? null
          : dateTimeFromString(widget.updateEvent!.eventDate!);

      Provider.of<MediaProvider>(context, listen: false).setImagePath(
          newPath: widget.updateEvent?.image ?? "", listen: false);
      Provider.of<HomeProvider>(context, listen: false)
          .setEventDate(date: date, listen: false);
      Provider.of<HomeProvider>(context, listen: false).setEventTime(
          time: widget.updateEvent?.eventTime.toString(), listen: false);
      _eventNameCtr?.text = widget.updateEvent?.eventName ?? "";
      _locationCtr?.text = widget.updateEvent?.location ?? "";
      _descCtr?.text = widget.updateEvent?.about ?? "";
    }
  }

  void disposeTextControllers() {
    _eventNameCtr?.dispose();
    _locationCtr?.dispose();
    _descCtr?.dispose();
  }

  void clearTextControllers() {
    _eventNameCtr?.clear();
    _locationCtr?.clear();
    _descCtr?.clear();
  }

  bool validateEventTextFields() {
    if (_eventNameCtr?.text.toString().trim() == "") {
      showToast("Enter Event Name");
      return false;
      //
    } else if (Provider.of<HomeProvider>(context, listen: false).eventDate ==
        null) {
      showToast("Please select event date");
      return false;
    } else if (Provider.of<HomeProvider>(context, listen: false).eventTime ==
        null) {
      showToast("Please select event time");
      return false;
    } else if (_locationCtr?.text.toString().trim() == "") {
      showToast("Enter Location");
      return false;
      //
    } else if (Provider.of<HomeProvider>(context, listen: false).selectedType ==
        Strings.selectType) {
      showToast("Please select event type");
      return false;
    } else if (_descCtr?.text.toString().trim() == "") {
      showToast("Enter Description");
      return false;
      //
    } else {
      return true;
    }
  }

  Future _showImagePickOptionDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return Consumer<MediaProvider>(builder: (context, provider, _) {
            return SimpleDialog(
              children: [
                SimpleDialogOption(
                    onPressed: () async {
                      Navigator.pop(context);
                      String imagePath =
                          await Utils.pickImage(source: ImageSource.camera);
                      provider.setImagePath(newPath: imagePath);
                    },
                    child: Row(children: [
                      Icon(Icons.camera_alt_outlined),
                      HGap(3.w),
                      Txt("Choose from camera")
                    ])),
                SimpleDialogOption(
                    onPressed: () async {
                      Navigator.pop(context);
                      String imagePath =
                          await Utils.pickImage(source: ImageSource.gallery);
                      provider.setImagePath(newPath: imagePath);
                    },
                    child: Row(children: [
                      Icon(Icons.image_outlined),
                      HGap(3.w),
                      Txt("Choose from gallery")
                    ])),
              ],
            );
          });
        });
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
                        child: Txt("Add New Event",
                            textColor: Colors.black,
                            fontsize: 3.t,
                            fontweight: FontWeight.bold),
                      ),
                      VGap(1.h),
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: _showImagePickOptionDialog,
                          child: Consumer<MediaProvider>(
                              builder: (context, provider, _) {
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.3.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(0.25),
                                  image: provider.imagePath.trim() == ""
                                      ? null
                                      : provider.imagePath.startsWith('http')
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  provider.imagePath),
                                              fit: BoxFit.cover)
                                          : DecorationImage(
                                              image: FileImage(
                                                  File(provider.imagePath)),
                                              fit: BoxFit.cover)),
                              child: Visibility(
                                  visible: provider.imagePath.trim() == "",
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                            );
                          }),
                        ),
                      ),
                      VGap(2.h),
                      Txt("Event Name",
                          textColor: Colors.black,
                          fontsize: 2.t,
                          fontweight: FontWeight.w500),
                      CustomTextField(
                          ctr: _eventNameCtr!,
                          hintText: "Enter an event name",
                          capitalization: TextCapitalization.words),
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
                                Consumer<HomeProvider>(
                                    builder: (context, provider, _) {
                                  return InkWell(
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      DateTime? eventDate =
                                          await showDatePicker(
                                              context: context,
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2026));
                                      provider.setEventDate(date: eventDate);
                                    },
                                    child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.w, vertical: 1.3.h),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey.withOpacity(0.25),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child:
                                                  Builder(builder: (context) {
                                                return Txt(provider.eventDate !=
                                                        null
                                                    ? getFormattedDate(
                                                        date: provider.eventDate
                                                            .toString())
                                                    : "Choose Date");
                                              }),
                                            ),
                                            Icon(Icons.date_range_outlined)
                                          ],
                                        )),
                                  );
                                }),
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
                                Consumer<HomeProvider>(
                                    builder: (context, provider, _) {
                                  return InkWell(
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      TimeOfDay? eventTime =
                                          await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now());
                                      formattedTimeOfDay = formattedTime(
                                          context,
                                          time: eventTime!,
                                          hrs24: true);

                                      provider.setEventTime(
                                          time: formattedTimeOfDay.toString());
                                    },
                                    child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.w, vertical: 1.3.h),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey.withOpacity(0.25),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child:
                                                  Builder(builder: (context) {
                                                return Txt(provider.eventTime !=
                                                        null
                                                    ? get12HrsTime(context,
                                                        time:
                                                            provider.eventTime!)
                                                    : "Choose Time");
                                              }),
                                            ),
                                            Icon(Icons.watch_later_outlined)
                                          ],
                                        )),
                                  );
                                }),
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
                          ctr: _locationCtr!,
                          hintText: "Enter a location",
                          capitalization: TextCapitalization.words),
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
                            FocusScope.of(context).unfocus();
                            _selectTypeDialog(context);
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
                                Consumer<HomeProvider>(
                                    builder: (context, provider, _) {
                                  return Txt(
                                    provider.selectedType,
                                    fontsize: 2.t,
                                  );
                                }),
                                Icon(Icons.arrow_drop_down)
                              ],
                            ),
                          )),
                      VGap(1.5.h),
                      Txt("Description",
                          textColor: Colors.black,
                          fontsize: 2.t,
                          fontweight: FontWeight.w500),
                      CustomTextField(
                          ctr: _descCtr!,
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
                          Expanded(child: Consumer<HomeProvider>(
                              builder: (context, provider, _) {
                            return ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.theme),
                                onPressed: () async {
                                  if (!provider.eventLoading) {
                                    final bool isValid =
                                        validateEventTextFields();
                                    if (!isValid) return;
                                    if (widget.updateEvent == null) {
                                      showLoader(context);
                                      String imageUrl = "";
                                      if (context
                                              .read<MediaProvider>()
                                              .imagePath
                                              .toString()
                                              .trim() !=
                                          "") {
                                        imageUrl = await context
                                            .read<MediaProvider>()
                                            .uploadImage(
                                                imagePath: context
                                                    .read<MediaProvider>()
                                                    .imagePath
                                                    .toString()
                                                    .trim());
                                      }
                                      final bool res =
                                          await provider.addNewEvent(
                                              eventName: _eventNameCtr!.text
                                                  .toString()
                                                  .trim(),
                                              date: provider.eventDate!
                                                  .toString(),
                                              image: imageUrl,
                                              time: provider.eventTime!,
                                              location: _locationCtr!.text
                                                  .toString()
                                                  .trim(),
                                              desc: _descCtr!.text
                                                  .toString()
                                                  .trim());
                                      hideLoader();
                                      if (res) {
                                        Navigator.pop(context);
                                        showFlushbar(context,
                                            "Event published successfully..!");
                                      }
                                    } else {
                                      final bool res = await provider.editEvent(
                                          eventId: widget.updateEvent!.eventId!,
                                          eventName: _eventNameCtr!.text
                                              .toString()
                                              .trim(),
                                          date: provider.eventDate!.toString(),
                                          time: provider.eventTime!,
                                          location: _locationCtr!.text
                                              .toString()
                                              .trim(),
                                          desc:
                                              _descCtr!.text.toString().trim());
                                      if (res) {
                                        Navigator.pop(context);
                                        showFlushbar(
                                            context, "Saved successfully..!");
                                      }
                                    }
                                  }
                                },
                                icon: Icon(Icons.check_circle,
                                    color: Colors.white),
                                label: Txt(
                                    widget.updateEvent == null
                                        ? "Publish"
                                        : "Save",
                                    textColor: Colors.white));
                          })),
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
      ),
    );
  }

  Future<dynamic> _selectTypeDialog(BuildContext context) async {
    final String? orgId = await Shared_Preferences.prefGetString(App.id, "");
    return showDialog(
        context: context,
        builder: (_) => StreamBuilder<List<EventType>>(
            stream: FireServices.instance.fetchEventTypeByOrg(orgId: orgId!),
            builder: (context, typeSnap) {
              return AlertDialog(
                  title: Txt("Select Type"),
                  scrollable: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  actions: [
                    TextButton(
                        onPressed: () {
                          if (typeSnap.hasData) {
                            Navigator.pop(context);
                            addItemDialog(context);
                          }
                        },
                        child: Txt("Add New Type"))
                  ],
                  actionsAlignment: MainAxisAlignment.center,
                  content: Builder(builder: (context) {
                    if (typeSnap.hasData) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            typeSnap.data!.length,
                            (index) => Consumer<HomeProvider>(
                                    builder: (context, provider, _) {
                                  return Container(
                                    width: 70.w,
                                    height: 6.h,
                                    child: SimpleDialogOption(
                                      onPressed: () {
                                        provider.setSelectedType(
                                            newType:
                                                typeSnap.data![index].name!);
                                        Navigator.pop(context);
                                      },
                                      child: Txt(
                                          "${typeSnap.data?[index].name ?? "--"}"),
                                    ),
                                  );
                                })),
                      );
                    } else if (typeSnap.hasError) {
                      return Center(
                        child: Icon(Icons.error, color: AppColor.theme),
                      );
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                        color: AppColor.theme,
                      ));
                    }
                  }));
            }));
  }

  /// --- ADD NEW TYPE DIALOG
  Future<dynamic> addItemDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext alertContext) {
        return NewTypeDialog();
      },
    );
  }
}

class NewTypeDialog extends StatefulWidget {
  const NewTypeDialog({
    super.key,
  });

  @override
  State<NewTypeDialog> createState() => _NewTypeDialogState();
}

class _NewTypeDialogState extends State<NewTypeDialog> {
  TextEditingController? _newTypeCtr;

  @override
  void initState() {
    super.initState();
    _newTypeCtr = TextEditingController();
  }

  @override
  void dispose() {
    _newTypeCtr?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Txt("Add a type"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CustomTextField(
            ctr: _newTypeCtr!,
            capitalization: TextCapitalization.words,
            hintText: "Enter new type",
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Txt("Cancel"),
                ),
              ),
              HGap(2),
              Expanded(
                child: Consumer<HomeProvider>(builder: (context, provider, _) {
                  return TextButton(
                    onPressed: () async {
                      if (_newTypeCtr?.text.toString().trim() == "") {
                        showToast("Enter type name..!");
                        return;
                      }
                      final bool res = await provider.addEventType(
                          typeName: _newTypeCtr!.text.toString().trim());

                      if (res) {
                        Navigator.pop(context);
                        provider.setSelectedType(
                            newType: _newTypeCtr!.text.toString().trim());
                        await showFlushbar(context, "Type added successfully");
                      }
                    },
                    child: Txt("Ok"),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
