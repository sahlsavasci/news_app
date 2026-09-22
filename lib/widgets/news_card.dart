import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/cache_config.dart';

import 'package:get/get.dart';
import 'package:news_app/controllers/bookmark_controller.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onTap;
  final bool isHeadline;
  final String heroTag;

  const NewsCard({
    super.key,
    required this.article,
    required this.onTap,
    this.isHeadline = false,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    if (isHeadline) {
      return _buildHeadlineCard(context);
    }
    return _buildStandardCard(context);
  }

  Widget _buildHeadlineCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: heroTag,
                  child: article.urlToImage != null
                      ? CachedNetworkImage(
                          cacheManager: CacheConfig.customCacheManager,
                          imageUrl: article.urlToImage!,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 220,
                            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => _buildPlaceholderImage(context),
                        )
                      : _buildPlaceholderImage(context),
                ),
                if (article.source?.name != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        article.source!.name!.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _buildBookmarkButton(context),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.title != null)
                    Text(
                      article.title!,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  if (article.publishedAt != null)
                    Text(
                      _formatDate(article.publishedAt),
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.6), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.newspaper, size: 64, color: Colors.white),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
      final amPm = date.hour >= 12 ? 'PM' : 'AM';
      final minute = date.minute.toString().padLeft(2, '0');
      return '${months[date.month - 1]} ${date.day}, $hour:$minute $amPm';
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildStandardCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.source?.name != null)
                    Text(
                      article.source!.name!.toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 6),
                  if (article.title != null)
                    Text(
                      article.title!,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                        height: 1.3,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (article.publishedAt != null)
                        Text(
                          _formatDate(article.publishedAt),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      _buildBookmarkButton(context, small: true),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            if (article.urlToImage != null)
              Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                  cacheManager: CacheConfig.customCacheManager,
                  imageUrl: article.urlToImage!,
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 100,
                    width: 100,
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 100,
                    width: 100,
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                    child: const Icon(Icons.image_not_supported, color: AppColors.textHint),
                  ),
                ),
              ),
            ),
            ],
          ),
      ),
    );
  }

  Widget _buildBookmarkButton(BuildContext context, {bool small = false}) {
    final BookmarkController bookmarkController = Get.find();
    return Obx(() {
      final isBookmarked = bookmarkController.isBookmarked(article);
      return GestureDetector(
        onTap: () => bookmarkController.toggleBookmark(article),
        child: Container(
          padding: EdgeInsets.all(small ? 4 : 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withValues(alpha: 0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: isBookmarked ? Theme.of(context).primaryColor : Colors.grey,
            size: small ? 18 : 24,
          ),
        ),
      );
    });
  }
}
