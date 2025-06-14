import 'package:get/get.dart';
import 'package:defino/screens/favorite/favourite_controller.dart';

class FavoriteBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoriteController());
  }
}
