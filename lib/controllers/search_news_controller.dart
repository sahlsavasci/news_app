import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/services/news_service.dart';

class SearchNewsController extends GetxController {
  final NewsService _newsService = Get.find<NewsService>();

  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final articles = <NewsArticle>[].obs;
  final error = ''.obs;
  final displayLimit = 5.obs;
  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    debounce(searchQuery, (_) => _performSearch(),
        time: const Duration(milliseconds: 500));
  }

  void updateQuery(String query) {
    searchQuery.value = query;
  }
  
  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  Future<void> _performSearch() async {
    final query = searchQuery.value.trim();
    if (query.isEmpty) {
      articles.clear();
      displayLimit.value = 5;
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final response = await _newsService.searchNews(query: query);
      articles.value = response.articles;
      displayLimit.value = 5;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to search news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showMoreItems() {
    if (displayLimit.value < articles.length) {
      displayLimit.value += 5;
    }
  }
}
