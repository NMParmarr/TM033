import 'package:eventflow/data/datasource/services/connection/network_service.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../utils/constants/color_constants.dart';
import '../../../../utils/text.dart';

class NetworkCheckerWidget extends StatelessWidget {
  final Widget child;

  const NetworkCheckerWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    NetworkStatus networkStatus = Provider.of<NetworkStatus>(context);

    return Scaffold(
      body: networkStatus == NetworkStatus.online ? child : const NoInternetWdget(),
    );
  }
}

class NoInternetWdget extends StatelessWidget {
  const NoInternetWdget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_){
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(Images.noInternetConnection),
              Txt("No Internet", fontsize: 4.t, textColor: AppColor.theme),
              Txt("Check your Internet Connection..!", fontsize: 1.5.t, textColor: Colors.black),
              SizedBox(height: 2.h),
              SizedBox(
                width: 55.w,
                // padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: ElevatedButton(
                    onPressed: () {
                      NetworkService.instance.checkConnection();
                    },
                    child: Txt("Retry", textColor: Colors.white, fontsize: 2.t, fontweight: FontWeight.w600)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
