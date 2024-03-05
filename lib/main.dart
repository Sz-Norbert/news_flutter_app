import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:news_flutter_app/pages/favorites_page.dart';
import 'package:news_flutter_app/pages/home_page.dart';
import 'package:news_flutter_app/pages/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  List<Widget> screens = [
    HomePage(),
    FavoritesPage(),
    SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: GNav(
          gap: 20,
          activeColor: Colors.blue,
          tabBackgroundColor: Colors.orange,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: "home",
            ),
            GButton(
              icon: Icons.favorite_border,
              text: "favorites",
            ),
            GButton(
              icon: Icons.calendar_today,
              text: "Calendar",
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
