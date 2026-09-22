import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_app/models/news_article.dart';

class BookmarkController extends GetxController {
  final _storage = GetStorage();
  final _bookmarks = <NewsArticle>[].obs;
  
  List<NewsArticle> get bookmarks => _bookmarks;

  @override
  void onInit() {
    super.onInit();
    _loadBookmarks();
  }

  void _loadBookmarks() {
    List<dynamic>? storedBookmarks = _storage.read<List<dynamic>>('bookmarks');
    if (storedBookmarks != null) {
      _bookmarks.value = storedBookmarks.map((e) => NewsArticle.fromJson(Map<String, dynamic>.from(e))).toList();
    }
  }

  void _saveBookmarks() {
    _storage.write('bookmarks', _bookmarks.map((e) => e.toJson()).toList());
  }

  bool isBookmarked(NewsArticle article) {
    if (article.url == null) return false;
    return _bookmarks.any((element) => element.url == article.url);
  }

  void toggleBookmark(NewsArticle article) {
    if (article.url == null) return;
    
    if (isBookmarked(article)) {
      _bookmarks.removeWhere((element) => element.url == article.url);
      Get.snackbar(
        'Removed from Bookmarks',
        'Article has been removed.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 1),
        margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
        backgroundColor: Get.theme.brightness == Brightness.dark ? Colors.white : Colors.black87,
        colorText: Get.theme.brightness == Brightness.dark ? Colors.black : Colors.white,
        borderRadius: 8,
        snackStyle: SnackStyle.FLOATING,
      );
    } else {
      _bookmarks.add(article);
      Get.snackbar(
        'Added to Bookmarks',
        'Article has been saved.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 1),
        margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
        backgroundColor: Get.theme.brightness == Brightness.dark ? Colors.white : Colors.black87,
        colorText: Get.theme.brightness == Brightness.dark ? Colors.black : Colors.white,
        borderRadius: 8,
        snackStyle: SnackStyle.FLOATING,
      );
    }
    _saveBookmarks();
  }
}
