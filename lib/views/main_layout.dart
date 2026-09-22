import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/views/home_view.dart';
import 'package:news_app/views/search_view.dart';
import 'package:news_app/views/bookmark_view.dart';
import 'package:news_app/views/settings_view.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final RxInt _currentIndex = 0.obs;

  final List<Widget> _pages = [
    const HomeView(),
    const SearchView(),
    const BookmarkView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: _currentIndex.value.clamp(0, _pages.length - 1),
        children: _pages,
      )),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _currentIndex.value.clamp(0, _pages.length - 1),
          onTap: (index) => _currentIndex.value = index,
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedItemColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                child: Icon(Icons.home, size: 28),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                child: Icon(Icons.search, size: 28),
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                child: Icon(Icons.bookmark_outline, size: 28),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                child: Icon(Icons.bookmark, size: 28),
              ),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                child: Icon(Icons.settings, size: 28),
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
