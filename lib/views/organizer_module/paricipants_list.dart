import 'package:eventflow/utils/common_toast.dart';
import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constants/image_constants.dart';

class ParticipantsList extends StatelessWidget {
  const ParticipantsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: AspectRatio(
            aspectRatio: 1,
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(Images.sampleImage)))),
          ),
          title: Txt("Neon Parmar", fontsize: 2.t, fontweight: FontWeight.w600),
          subtitle: Txt("+91 8141809076"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    showToast("User Deleted or removed");
                  },
                  icon: Icon(Icons.delete, color: AppColor.darkRed)),
              IconButton(
                  onPressed: () {
                    try {
                      launchUrl(Uri.parse('tel://8141809076'));
                    } catch (e) {
                      showToast("Something went wrong");
                    }
                  },
                  icon: Icon(
                    Icons.call,
                    color: AppColor.theme,
                  )),
            ],
          ),
        );
      },
    );
  }
}
