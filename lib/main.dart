import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get_storage/get_storage.dart';

import 'package:defino/model/db_model.dart';
import 'package:defino/utils/colors.dart';
import 'routes/pages.dart';
import 'routes/routes.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Change to your preferred color
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    await GetStorage.init();

    final Directory? appDir = await getApplicationDocumentsDirectory();
    Hive
      ..init(appDir!.path)
      ..registerAdapter(WordsModelAdapter());

    await Hive.openBox<SaveWordsModel>('savedWords');

    await _initializeApp();
    runApp(const MyApp());
  } catch (e, s) {
    debugPrint('Initialization error: $e\n$s');
  }
}

Future<void> _initializeApp() async {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.primary,
            statusBarIconBrightness: Brightness.light, // Android
            statusBarBrightness: Brightness.light, // iOS
          ),
        ),
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      builder: EasyLoading.init(),
    );
  }
}
