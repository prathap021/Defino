import 'package:defino/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:defino/screens/splash/splash_controller.dart';

class Splashview extends StatelessWidget {
  final splash = Get.put(SplashController());

  Splashview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() => Transform.scale(
          scale: splash.scale.value,
          child: const Text(
            "Defino",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        )),
      ),
    );
  }
}
