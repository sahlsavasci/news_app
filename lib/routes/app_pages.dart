import 'package:get/get.dart';
import 'package:news_app/bindings/home_binding.dart';
import 'package:news_app/views/home_view.dart';
import 'package:news_app/views/news_detail_view.dart';
import 'package:news_app/views/splash_view.dart';
import 'package:news_app/views/main_layout.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.SPLASH;

  static final routes = [
    GetPage(name: _Paths.SPLASH, page: () => SplashView()),
    GetPage(name: _Paths.MAIN, page: () => MainLayout(), binding: HomeBinding()),
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(name: _Paths.NEWS_DETAIL, page: () => NewsDetailView()),
  ];
}
