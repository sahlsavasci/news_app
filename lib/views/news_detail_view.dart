import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/cache_config.dart';
import 'package:news_app/controllers/bookmark_controller.dart';

class NewsDetailView extends StatelessWidget {
  const NewsDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Get.arguments == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/main');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
    final NewsArticle article = args['article'] as NewsArticle;
    final String heroTag = args['heroTag'] as String;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroImage(article, heroTag),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Obx(() {
                    final BookmarkController bookmarkController = Get.find();
                    final isBookmarked = bookmarkController.isBookmarked(article);
                    return IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border, 
                        color: isBookmarked ? Theme.of(context).primaryColor : Colors.white, 
                        size: 20
                      ),
                      onPressed: () => bookmarkController.toggleBookmark(article),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Colors.white, size: 20),
                    onPressed: () => _shareArticle(article),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
                onSelected: (value) {
                  switch (value) {
                    case 'copy_link':
                      _copyLink(article);
                      break;
                    case 'open_browser':
                      _openInBrowser(article);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'copy_link',
                    child: Row(
                      children: [
                        Icon(Icons.copy),
                        SizedBox(width: 8),
                        Text('Copy Link'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'open_browser',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_browser),
                        SizedBox(width: 8),
                        Text('Open in Browser'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source and Date
                  Row(
                    children: [
                      if (article.source?.name != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            article.source!.name!,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (article.publishedAt != null) ...[
                        Text(
                          timeago.format(DateTime.parse(article.publishedAt!)),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title
                  if (article.title != null) ...[
                    Text(
                      article.title!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Description
                  if (article.description != null) ...[
                    Text(
                      article.description!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Content
                  if (article.content != null) ...[
                    Text(
                      'Content',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleMedium?.color ?? AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.content!.replaceAll(RegExp(r'\[\+\d+\s*chars\]'), '').trim(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Read More Button
                  if (article.url != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _openInBrowser(article),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Read Full Article',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(NewsArticle article, String heroTag) {
    if (article.urlToImage != null) {
      return Hero(
        tag: heroTag,
        child: CachedNetworkImage(
          cacheManager: CacheConfig.customCacheManager,
          imageUrl: article.urlToImage!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Theme.of(context).dividerColor,
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            color: Theme.of(context).dividerColor,
            child: const Icon(
              Icons.image_not_supported,
              size: 64,
              color: AppColors.textHint,
            ),
          ),
        ),
      );
    }
    return Container(
      color: AppColors.primary,
      child: const Center(
        child: Icon(
          Icons.newspaper,
          size: 80,
          color: Colors.white,
        ),
      ),
    );
  }

  void _shareArticle(NewsArticle article) {
    if (article.url != null) {
      // ignore: deprecated_member_use
      Share.share(
        '${article.title ?? 'Check out this news'}\n\n${article.url!}',
        subject: article.title,
      );
    }
  }

  void _copyLink(NewsArticle article) {
    if (article.url != null) {
      Clipboard.setData(ClipboardData(text: article.url!));
      Get.snackbar(
        'Success',
        'Link copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _openInBrowser(NewsArticle article) async {
    if (article.url != null) {
      final Uri url = Uri.parse(article.url!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open the link',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
