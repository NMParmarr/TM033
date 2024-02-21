/////////////////////////////////////////////////////////////////////////////////////////
///------------[ USES_GUIDE ]-----------
///
/// INSERT THIS LINE IN void main() FUNCTION --
/// await NetworkService.instance.startConnectionStreaming();
///
/// INSERT THIS LINE IN MULTIPROVIDER LIST IN main() METHOD--
/// StreamProvider(create: (context) => NetworkService.instance.controller.stream, initialData: NetworkStatus.offline),
///
/// WRAP ALL MAIN SCAFFOLD (WHICH ARE RETURNING TO build()) WITH 'NetworkCheckerWidget'--
///    return NetworkCheckerWidget(
///        child: Scaffold(...)
///     );
/////////////////////////////////////////////////////////////////////////////////////////

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkStatus { online, offline }

class NetworkService {
  NetworkService._();

  static NetworkService get instance => _instance;
  static final _instance = NetworkService._();

  StreamController<NetworkStatus> controller = StreamController();

  Future<void> startConnectionStreaming() async {
    checkConnection();
    Connectivity().onConnectivityChanged.listen((result) {
      controller.add(_networkStatus(result));
    });
  }

  void checkConnection() {
    Connectivity().checkConnectivity().then((result) => controller.add(_networkStatus(result)));
  }

  NetworkStatus _networkStatus(ConnectivityResult connectivityResult) {
    return connectivityResult == ConnectivityResult.none ? NetworkStatus.offline : NetworkStatus.online;
  }
}
