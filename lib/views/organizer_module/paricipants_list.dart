import 'package:eventflow/data/datasource/services/firebase/firebase_services.dart';
import 'package:eventflow/data/models/participant.dart';
import 'package:eventflow/utils/common_toast.dart';
import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/user_model.dart';
import '../../utils/constants/image_constants.dart';

class ParticipantsList extends StatelessWidget {
  final List<Participant> participants;
  const ParticipantsList({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    return participants.length <= 0
        ? Txt(
            "No Participant joined yet..!",
            textColor: AppColor.theme,
          )
        : ListView.builder(
            itemCount: participants.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return StreamBuilder<UserModel>(
                  stream: FireServices.instance
                      .fetchSingleUser(id: participants[index].userId!),
                  builder: (context, user) {
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
                      title: Txt(user.data?.name ?? "---",
                          fontsize: 2.t, fontweight: FontWeight.w600),
                      subtitle: Builder(builder: (context) {
                        final String? formattedDate = (user.data != null &&
                                user.data?.joinDate != null)
                            ? DateFormat('dd-MM-yyyy hh:mm a')
                                .format(DateTime.parse(user.data!.joinDate!))
                            : null;
                        return Txt(
                            "Join: ${formattedDate ?? "--/--/---- --:--"}");
                      }),
                      trailing: IconButton(
                          onPressed: () {
                            if (user.data?.mobile != null) {
                              try {
                                launchUrl(
                                    Uri.parse('tel://${user.data?.mobile}'));
                              } catch (e) {
                                showToast("Something went wrong");
                              }
                            }
                          },
                          icon: Icon(
                            Icons.call,
                            color: AppColor.theme,
                          )),
                    );
                  });
            },
          );
  }
}
