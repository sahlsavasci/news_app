import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_app/bindings/app_bindings.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';

import 'package:news_app/controllers/settings_controller.dart';
import 'package:news_app/controllers/bookmark_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');
  await GetStorage.init();
  
  Get.put(SettingsController(), permanent: true);
  Get.put(BookmarkController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    
    return GetMaterialApp(
      title: 'Lumina News',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryDark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkSurface,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardColor: AppColors.darkSurface,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      themeMode: settings.themeMode.value == 'dark' 
          ? ThemeMode.dark 
          : (settings.themeMode.value == 'light' ? ThemeMode.light : ThemeMode.system),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Obx(() {
          final scale = settings.fontScale.value;

          final data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(
              textScaler: TextScaler.linear(scale),
            ),
            child: child!,
          );
        });
      },
    );
  }
}
