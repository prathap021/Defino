import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:defino/routes/pages.dart';
import 'package:defino/utils/colors.dart';
import '../favorite/favourite_view.dart';
import 'homepage_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController homeCtrl = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, res) {
        homeCtrl.focusNode.unfocus();
      },
      child: SafeArea(
        child: Obx(
          () => Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar:
                homeCtrl.selectedIndex.value == 0
                    ? _buildAppBar(context)
                    : null,
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.square_fill_line_vertical_square),
                  label: 'Favourite',
                ),
              ],
              currentIndex: homeCtrl.selectedIndex.value,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey,
              onTap: homeCtrl.onItemTapped,
            ),
            body:
                homeCtrl.selectedIndex.value == 0
                    ? _buildSearchView(context)
                    : Favoritewords(),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      title: Text(
        "Defino",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.language, color: Colors.white),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: homeCtrl.wordController.value,
            focusNode: homeCtrl.focusNode,
            onChanged: (query) {
              if (query.isNotEmpty) {
                homeCtrl.debouncer.run(() => homeCtrl.searchWords(query));
              } else {
                homeCtrl.isLoading.value = false;
                homeCtrl.hasMore.value = true;
                homeCtrl.debouncer.dispose();
                homeCtrl.findedWords.clear();
              }
            },
            onFieldSubmitted: homeCtrl.searchWords,
            decoration: InputDecoration(
              hintText: "Search for something...",
              hintStyle: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: Colors.black54),
              prefixIcon: const Icon(Icons.search, color: Colors.black54),
              suffixIcon: const Icon(Icons.mic, color: Colors.black54),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchView(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        controller: homeCtrl.scrollController,
        itemCount:
            homeCtrl.findedWords.length +
            (homeCtrl.isLoading.value || !homeCtrl.hasMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < homeCtrl.findedWords.length) {
            final word = homeCtrl.findedWords[index];
            return ListTile(
              leading: Text("${index + 1}"),
              title: Text(word.title ?? ""),
              trailing: GestureDetector(
                onTap:
                    () => homeCtrl.toggleSaveWord(
                      word.title ?? '',
                      word.snippet ?? '',
                    ),
                child: Icon(
                  word.selected == true
                      ? Icons.bookmark
                      : Icons.bookmark_add_outlined,
                  color:
                      word.selected == true ? AppColors.primary : Colors.grey,
                ),
              ),
              onTap:
                  () =>
                      Get.toNamed(AppRoutes.wordsDescription, arguments: word),
            );
          } else if (homeCtrl.isLoading.value) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (!homeCtrl.hasMore.value) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: Text("No more data")),
            );
          } else {
            return const SizedBox();
          }
        },
      );
    });
  }
}
