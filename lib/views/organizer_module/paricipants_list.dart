import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:flutter/material.dart';

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
          title: Txt("Neon Parmar", fontsize: 2.t, fontweight: FontWeight.w500),
          subtitle: Txt("+91 8141809076"),
        );
      },
    );
  }
}
