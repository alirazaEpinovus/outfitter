import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionNotifier {
  // Create our public controller
  ConnectivityStatus connectivityStatus;
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  ConnectionNotifier() {
    // Subscribe to the connectivity Chanaged Steam
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectionStatusController.add(_getStatusFromResult(result));
    });
  }

  ConnectivityStatus get conn => connectivityStatus;

  // Convert from the third part enum to our own enum
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    print('connection === $result ');
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}

enum ConnectivityStatus { WiFi, Cellular, Offline }
