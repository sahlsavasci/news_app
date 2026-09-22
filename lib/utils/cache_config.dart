import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheConfig {
  static const key = 'customCacheKey';

  static CacheManager customCacheManager = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 200,
    ),
  );
}
