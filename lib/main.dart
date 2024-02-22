import 'package:eventflow/utils/constants/color_constants.dart';
import 'package:eventflow/viewmodels/providers/auth_provider.dart';
import 'package:eventflow/viewmodels/providers/home_provider.dart';
import 'package:eventflow/viewmodels/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'data/datasource/services/connection/network_service.dart';
import 'data/datasource/services/firebase/firebase_messaging.dart';
import 'di_container.dart' as di;
import 'resources/routes/routes.dart';
import 'utils/constants/app_constants.dart';
import 'utils/size_config.dart';
import 'viewmodels/providers/theme_provider.dart';
import 'package:eventflow/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

/// 1/5: define a navigator key
// final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FireMessaging.instance.initMessaging();

  await di.init();

  await NetworkService.instance.startConnectionStreaming();
  
  runApp(MultiProvider(
    providers: [
      StreamProvider(
          create: (context) => NetworkService.instance.controller.stream,
          initialData: NetworkStatus.offline),
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<HomeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return OrientationBuilder(
          builder: (BuildContext context2, Orientation orientation) {
        SizeConfig.init(constraints, orientation);
        return MaterialApp(
          navigatorKey: MyApp.navigatorKey,
          color: AppColor.theme,
          title: App.appName,
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => AppColor.theme))),
              // useMaterial3: false,
              colorScheme: ColorScheme.fromSeed(seedColor: AppColor.theme),
              iconTheme: IconThemeData(color: AppColor.theme),
              primaryColor: AppColor.theme,
              primarySwatch: AppColor().getMaterialColor(AppColor.theme)),
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.splashScreen,
          onGenerateRoute: Routes.generateRoute,
        );
      });
    });
  }
}
