import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/category_chip.dart';
import 'package:news_app/widgets/loading_shimmer.dart';

class HomeView extends GetView<NewsController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.2,
            ),
            children: [
              TextSpan(text: 'lumina', style: TextStyle(color: Theme.of(context).primaryColor)),
              TextSpan(text: '!', style: TextStyle(color: Theme.of(context).primaryColor, fontStyle: FontStyle.italic)),
              TextSpan(text: ' news', style: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Theme.of(context).appBarTheme.foregroundColor),
            onPressed: () {
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  backgroundColor: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.notifications_active, color: AppColors.primary, size: 40),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'You\'re all caught up!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'There are no new notifications at the moment. Check back later for breaking news alerts.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Get.back(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Got it', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Categories
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return Obx(() => Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 16.0 : 12.0,
                    right: index == controller.categories.length - 1 ? 16.0 : 12.0,
                  ),
                  child: CategoryChip(
                    label: category == 'general' ? 'For You' : category.capitalizeFirst!,
                    isSelected: controller.selectedCategory == category,
                    onTap: () => controller.selectCategory(category),
                  ),
                ));
              },
            ),
          ),

          // News List
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return LoadingShimmer();
              }

              if (controller.error.isNotEmpty) {
                return _buildErrorWidget();
              }

              if (controller.articles.isEmpty) {
                return _buildEmptyWidget();
              }

              final int carouselCount = controller.articles.length > 5 ? 5 : controller.articles.length;
              final int verticalCount = controller.articles.length > 5 ? controller.articles.length - 5 : 0;
              final int displayedVerticalCount = verticalCount < controller.displayLimit.value ? verticalCount : controller.displayLimit.value;

              return RefreshIndicator(
                onRefresh: controller.refreshNews,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: displayedVerticalCount + 2,
                  itemBuilder: (context, index) {

                      if (index == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                              child: Text(
                                'Top stories',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                                ),
                              ),
                            ),
                            if (carouselCount > 0)
                              SizedBox(
                                height: 380,
                                child: PageView.builder(
                                  controller: PageController(viewportFraction: 0.95),
                                  padEnds: false,
                                  itemCount: carouselCount,
                                  itemBuilder: (context, carouselIndex) {
                                    final article = controller.articles[carouselIndex];
                                    final heroTag = 'hero_carousel_${carouselIndex}_${article.url ?? article.title}';
                                    return Padding(
                                      padding: EdgeInsets.only(left: carouselIndex == 0 ? 16.0 : 0, right: 16.0),
                                      child: NewsCard(
                                        article: article,
                                        isHeadline: true,
                                        heroTag: heroTag,
                                        onTap: () => Get.toNamed(Routes.NEWS_DETAIL, arguments: {'article': article, 'heroTag': heroTag}),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        );
                      }

                      if (index == displayedVerticalCount + 1) {
                        return Obx(() {
                          if (controller.isLoadMore) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (displayedVerticalCount < verticalCount || !controller.hasReachedMax) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                              child: ElevatedButton(
                                onPressed: controller.showMoreItems,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Show More',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }
                          return const SizedBox(height: 100); // Space for bottom nav
                        });
                      }

                      final int articleIndex = carouselCount + (index - 1);
                      final article = controller.articles[articleIndex];
                      final heroTag = 'hero_vertical_${articleIndex}_${article.url ?? article.title}';

                      return Column(
                        children: [
                          NewsCard(
                            article: article,
                            isHeadline: false,
                            heroTag: heroTag,
                            onTap: () => Get.toNamed(Routes.NEWS_DETAIL, arguments: {'article': article, 'heroTag': heroTag}),
                          ),
                          if (index < displayedVerticalCount)
                            Divider(height: 1, thickness: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
                        ],
                      );
                    },
                  ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please check your internet connection',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: controller.refreshNews,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.newspaper, size: 64, color: AppColors.textHint),
          SizedBox(height: 16),
          Text(
            'No news available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please try again later',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
