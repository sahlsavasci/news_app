import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/services/news_service.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<NewsService>(NewsService(), permanent: true);
    Get.put<NewsController>(NewsController(), permanent: true);
  }
}
