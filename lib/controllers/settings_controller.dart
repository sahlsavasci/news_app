import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_app/controllers/news_controller.dart' as news;

class SettingsController extends GetxController {
  final _storage = GetStorage();
  
  // Observables
  final themeMode = 'system'.obs;
  final fontScale = 1.0.obs;
  final region = 'us'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    themeMode.value = _storage.read('themeMode') ?? 'system';
    fontScale.value = _storage.read('fontScale') ?? 1.0;
    region.value = _storage.read('region') ?? 'us';

    // Apply the saved theme immediately upon initialization
    _applyTheme(themeMode.value);
  }

  void setThemeMode(String mode) {
    themeMode.value = mode;
    _storage.write('themeMode', mode);
    _applyTheme(mode);
  }

  void _applyTheme(String mode) {
    if (mode == 'dark') {
      Get.changeThemeMode(ThemeMode.dark);
    } else if (mode == 'light') {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.system);
    }
  }

  void setFontScale(double scale) {
    fontScale.value = scale;
    _storage.write('fontScale', scale);
  }

  void setRegion(String newRegion) {
    region.value = newRegion;
    _storage.write('region', newRegion);
    
    // Refresh news when region changes
    if (Get.isRegistered<news.NewsController>()) {
      Get.find<news.NewsController>().refreshNews();
    }
  }
}
