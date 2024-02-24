import 'package:eventflow/resources/helper/loader.dart';
import 'package:eventflow/utils/common_toast.dart';
import 'package:eventflow/utils/common_utils.dart';
import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:eventflow/viewmodels/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/user_model.dart';
import '../../utils/constants/image_constants.dart';
import '../../utils/widgets/custom_network_image.dart';

class UsersList extends StatelessWidget {
  final List<UserModel> usersList;
  const UsersList({super.key, required this.usersList});

  @override
  Widget build(BuildContext context) {
    return usersList.length <= 0
        ? Txt(
            "No Participant joined yet..!",
            textColor: AppColor.theme,
          )
        : ListView.builder(
            itemCount: usersList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: AspectRatio(
                    aspectRatio: 1,
                    child: (usersList[index].image != null && usersList[index].image?.trim() != "")
                        ? usersList[index].image!.startsWith('http')
                            ? ClipOval(
                                child: CustomNetworkImage(
                                  url: usersList[index].image!,
                                ),
                              )
                            : ClipOval(
                                child: Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: AssetImage(Images.userPlaceholder), fit: BoxFit.cover)),
                                ),
                              )
                        : ClipOval(
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: AssetImage(Images.userPlaceholder), fit: BoxFit.cover)),
                            ),
                          )),
                title: Txt(usersList[index].name ?? "---", fontsize: 2.t, fontweight: FontWeight.w600),
                subtitle: Txt(usersList[index].mobile != null ? "+91 ${usersList[index].mobile!}" : "-----"),
                trailing: Builder(builder: (context) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Consumer<ProfileProvider>(builder: (context, provider, _) {
                        return IconButton(
                            onPressed: () {
                              Utils.deleteUserDialog(context, username: usersList[index].name ?? "--", onYes: () async {
                                showLoader(context);
                                final bool res = await provider.deleteUser(userId: usersList[index].id!);
                                hideLoader();
                                if (res) {
                                  showToast("User Deleted or removed");
                                }
                              });
                            },
                            icon: Icon(Icons.delete, color: AppColor.darkRed));
                      }),
                      IconButton(
                          onPressed: () {
                            if (usersList[index].mobile != null) {
                              try {
                                launchUrl(Uri.parse('tel://${usersList[index].mobile}'));
                              } catch (e) {
                                showToast("Something went wrong");
                              }
                            }
                          },
                          icon: Icon(
                            Icons.call,
                            color: AppColor.theme,
                          )),
                    ],
                  );
                }),
              );
            },
          );
  }
}
