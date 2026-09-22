import 'package:get/get.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/utils/constants.dart';
import 'package:news_app/controllers/settings_controller.dart';

class NewsController extends GetxController {
  final NewsService _newsService = Get.find<NewsService>();

  // Observable variables
  final _isLoading = false.obs;
  final _articles = <NewsArticle>[].obs;
  final _selectedCategory = 'general'.obs;
  final _error = ''.obs;

  // Pagination variables
  final _currentPage = 1.obs;
  final _isLoadMore = false.obs;
  final _hasReachedMax = false.obs;
  final displayLimit = 5.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<NewsArticle> get articles => _articles;
  String get selectedCategory => _selectedCategory.value;
  String get error => _error.value;
  List<String> get categories => Constants.categories;
  bool get isLoadMore => _isLoadMore.value;
  bool get hasReachedMax => _hasReachedMax.value;

  @override
  void onInit() {
    super.onInit();
    fetchTopHeadlines();
  }

  Future<void> fetchTopHeadlines({String? category}) async {
    try {
      _isLoading.value = true;
      _error.value = '';
      _currentPage.value = 1;
      _hasReachedMax.value = false;
      displayLimit.value = 5;

      final settings = Get.find<SettingsController>();

      final response = await _newsService.getTopHeadlines(
        category: category ?? _selectedCategory.value,
        page: _currentPage.value,
        country: settings.region.value,
      );

      _articles.value = response.articles;
      if (response.articles.isEmpty) {
        _hasReachedMax.value = true;
      }
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (_isLoadMore.value || _hasReachedMax.value || _isLoading.value) return;

    try {
      _isLoadMore.value = true;
      _currentPage.value++;

      final settings = Get.find<SettingsController>();

      final response = await _newsService.getTopHeadlines(
        category: _selectedCategory.value,
        page: _currentPage.value,
        country: settings.region.value,
      );

      if (response.articles.isEmpty) {
        _hasReachedMax.value = true;
      } else {
        _articles.addAll(response.articles);
        displayLimit.value += 5;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load more news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoadMore.value = false;
    }
  }

  void showMoreItems() {
    int verticalCount = _articles.length > 5 ? _articles.length - 5 : 0;
    if (displayLimit.value < verticalCount) {
      displayLimit.value += 5;
    } else if (!_hasReachedMax.value) {
      // Increase limit so that when new data arrives, it will be displayed
      displayLimit.value += 5;
      loadMore();
    }
  }

  Future<void> refreshNews() async {
    await fetchTopHeadlines();
  }

  void selectCategory(String category) {
    if (_selectedCategory.value != category) {
      _selectedCategory.value = category;
      fetchTopHeadlines(category: category);
    }
  }

  Future<void> searchNews(String query) async {
    if (query.isEmpty) return;

    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await _newsService.searchNews(query: query);
      _articles.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to search news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
