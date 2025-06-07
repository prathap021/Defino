import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkChecker {
  // Returns true if any type of connection is available
  static Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }
}
