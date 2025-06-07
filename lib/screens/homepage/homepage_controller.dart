import 'package:defino/database/dbhelper.dart';
import 'package:defino/model/words_model.dart';
import 'package:defino/screens/favorite/favourite_controller.dart';
import 'package:defino/utils/connectivity.dart';
import 'package:defino/utils/constants.dart';
import 'package:defino/utils/debouncer.dart';
import 'package:defino/utils/network_constants.dart';
import 'package:defino/utils/update_services.dart';
import 'package:defino/widgets/commonwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../model/db_model.dart';
import '../../services/apiServices.dart';
import '../../utils/colors.dart';

class HomeController extends GetxController {
  // Controllers & Keys
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>().obs;
  final wordController = TextEditingController().obs;
  final scrollController = ScrollController();

  // Helpers
  final _apiService = ApiService();
  final debouncer = Debouncer(milliseconds: 400);
  final _dbHelper = Dbhelper();

  // Observables
  final selectedIndex = 0.obs;
  final findedWords = <Tamilwords>[].obs;

  final isLoading = false.obs;
  final hasMore = true.obs;
  final _pageSize = 20;
  final _currentPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary, // Change to your preferred color
        statusBarIconBrightness: Brightness.light,
      ),
    );
    AppUpdateService.checkAndUpdate();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    debouncer.dispose();
    scrollController.dispose();
    wordController.value.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoading.value &&
        hasMore.value) {
      fetchNextPage();
    }
  }

  void onItemTapped(int index) {
    selectedIndex.value = index;
    Get.delete<FavoriteController>();
  }

  /// Called when user starts a new search
  void searchWords(String query) {
    _currentPage.value = 1;
    hasMore.value = true;
    fetchWords(query, isFirstPage: true);
  }

  /// Fetch next page in pagination
  void fetchNextPage() {
    fetchWords(wordController.value.text);
  }

  /// Core API fetch logic
  Future<void> fetchWords(String query, {bool isFirstPage = false}) async {
    if (isLoading.value || query.isEmpty) return;

    isLoading.value = true;

    try {
      if (await NetworkChecker.isConnected()) {
        // if (isFirstPage) EasyLoading.show();

        final response = await _apiService.get(
          NetworkConstants.baseUrl,
          queryParameters: {
            NetworkConstants.action: AppConstants.query,
            NetworkConstants.format: AppConstants.json,
            NetworkConstants.list: AppConstants.search,
            NetworkConstants.sroffset: _currentPage.value,
            NetworkConstants.srlimit: _pageSize,
            NetworkConstants.srsearch: query,
          },
        );

        if (response.statusCode == 200) {
          final parsed =
              (response.data["query"]["search"] as List)
                  .cast<Map<String, dynamic>>();

          final newWords = await Future.wait(
            parsed.map((json) async {
              final title = json['title'] ?? "";
              final snippet = json['snippet'] ?? "";
              final isSaved = await _dbHelper.isWordExist(title);
              return Tamilwords(
                title: title,
                snippet: snippet,
                selected: isSaved,
              );
            }),
          );

          if (isFirstPage) {
            findedWords.assignAll(newWords);
          } else {
            findedWords.addAll(newWords);
          }

          if (newWords.length < _pageSize) {
            hasMore.value = false;
          } else {
            _currentPage.value++;
          }
        } else {
          throw Exception("Error: ${response.statusCode}");
        }
      } else {
        ResponseWidget.showToast("Please check your connectivity");
      }
    } catch (e, s) {
      ResponseWidget.showToast("Something went wrong");
      debugPrint("Error: $e\n$s");
    } finally {
      isLoading.value = false;
    }
  }

  /// Save or Remove word from DB
  Future<void> toggleSaveWord(String title, String body) async {
    final exists = await _dbHelper.isWordExist(title);
    if (!exists) {
      _dbHelper.setWords(SaveWordsModel(id: '', title: title, body: body));
    } else {
      _dbHelper.removeWords(title);
    }

    // Refresh current list with updated 'selected' state
    searchWords(wordController.value.text);
  }
}
