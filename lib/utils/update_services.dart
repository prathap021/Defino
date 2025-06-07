import 'package:in_app_update/in_app_update.dart';

class AppUpdateService {
  /// Checks for an available update and performs it (immediate or flexible).
  static Future<void> checkAndUpdate({bool flexible = false}) async {
    try {
      final AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (flexible) {
          // Non-blocking update
          await InAppUpdate.startFlexibleUpdate();
          await InAppUpdate.completeFlexibleUpdate();
        } else {
          // Blocking full-screen update
          await InAppUpdate.performImmediateUpdate();
        }
      } else {
        print("No update available.");
      }
    } catch (e) {
      print("App update check failed: $e");
    }
  }
}
