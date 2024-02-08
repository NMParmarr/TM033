import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(children: [
          // VGap(2.h),
          CustomTextField(
              ctr: TextEditingController(),
              prefixIcon: Icon(Icons.search),
              hintText: "Search"),
          TabBar(
              tabs: List.generate(
                  4,
                  (index) => Tab(
                        text: "All",
                      )))
        ]),
      ),
    );
  }
}
