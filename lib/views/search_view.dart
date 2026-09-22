import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/search_news_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/loading_shimmer.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchNewsController());

    return Scaffold(
      appBar: AppBar(title: const Text('Search'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => TextField(
              controller: controller.textController,
              onChanged: controller.updateQuery,
              decoration: InputDecoration(
                hintText: 'Search for news...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.textController.clear();
                          controller.updateQuery('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark 
                    ? Theme.of(context).cardColor 
                    : Colors.grey[200],
              ),
            )),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadingShimmer();
              }
              if (controller.error.value.isNotEmpty) {
                return Center(child: Text('Error: ${controller.error.value}'));
              }
              if (controller.articles.isEmpty &&
                  controller.searchQuery.value.isNotEmpty) {
                return const Center(child: Text('No results found'));
              }
              if (controller.articles.isEmpty) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommended Topics',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          'Technology', 'Business', 'Sports', 'Entertainment', 'Health', 'Science'
                        ].map((topic) => ActionChip(
                          label: Text(topic),
                          onPressed: () {
                            controller.textController.text = topic;
                            controller.updateQuery(topic);
                          },
                          backgroundColor: Theme.of(context).cardColor,
                          side: BorderSide(color: Theme.of(context).dividerColor),
                        )).toList(),
                      ),
                    ],
                  ),
                );
              }

              final int totalArticles = controller.articles.length;
              final int displayedCount = totalArticles < controller.displayLimit.value
                  ? totalArticles
                  : controller.displayLimit.value;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: displayedCount + (displayedCount < totalArticles ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == displayedCount) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
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

                  final article = controller.articles[index];
                  final heroTag = 'search_hero_${index}_${article.url ?? article.title}';
                  return NewsCard(
                    article: article,
                    onTap: () =>
                        Get.toNamed(Routes.NEWS_DETAIL, arguments: {'article': article, 'heroTag': heroTag}),
                    heroTag: heroTag,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
