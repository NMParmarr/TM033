
import 'package:eventflow/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../utils/constants/color_constants.dart';


BuildContext? c;
showLoader(context){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      c = MyApp.navigatorKey.currentContext;
      return LoaderPage();
    },
  );
}

hideLoader(){
  Navigator.pop(c!);
}


class LoaderPage extends StatefulWidget {

  @override
  AddPromptPageState createState() => AddPromptPageState();
}

class AddPromptPageState extends State<LoaderPage> {
  TextEditingController nameAlbumController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return animatedDialogueWithTextFieldAndButton(context);
  }


  animatedDialogueWithTextFieldAndButton(context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop){
        return;
      },
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4.w)),
                child: Container(
                  color: Colors.white,
                  padding:
                  EdgeInsets.only(left: 8.w, right: 8.w, top: 8.w, bottom: 8.w),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: CircularProgressIndicator(color: AppColor.theme),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
