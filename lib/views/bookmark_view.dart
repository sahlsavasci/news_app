import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/bookmark_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/widgets/news_card.dart';

class BookmarkView extends StatelessWidget {
  const BookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    final BookmarkController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Articles'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.bookmarks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bookmark_border, size: 64, color: AppColors.textHint),
                const SizedBox(height: 16),
                const Text(
                  'No saved articles yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Articles you bookmark will appear here.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.bookmarks.length,
          itemBuilder: (context, index) {
            final article = controller.bookmarks[index];
            final heroTag = 'hero_bookmark_${index}_${article.url ?? article.title}';
            return Column(
              children: [
                NewsCard(
                  article: article,
                  isHeadline: false,
                  heroTag: heroTag,
                  onTap: () => Get.toNamed(Routes.NEWS_DETAIL, arguments: {'article': article, 'heroTag': heroTag}),
                ),
                if (index < controller.bookmarks.length - 1)
                  Divider(height: 1, thickness: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
              ],
            );
          },
        );
      }),
    );
  }
}
