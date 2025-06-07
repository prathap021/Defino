import 'package:get/get.dart';

import 'package:defino/screens/Description/description_view.dart';
import 'package:defino/screens/favorite/favourite_view.dart';
import 'package:defino/screens/homepage/homepage_binding.dart';
import 'package:defino/screens/homepage/homepage_view.dart';
import 'package:defino/screens/splash/splash_view.dart';
import 'package:defino/screens/favorite/favourite_binding.dart';

import 'pages.dart';

class AppPages {
  static var pages = [
    GetPage(
      transition: Transition.fadeIn,
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      name: AppRoutes.wordsDescription,
      page: () => DescriptionView(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      name: AppRoutes.favorite,
      page: () => Favoritewords(),
      binding: FavoriteBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      name: AppRoutes.splash,
      page: () => Splashview(),
    ),
  ];
}
