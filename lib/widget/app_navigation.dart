import 'package:flutter/material.dart';
import 'package:x_skill/pages/home_page.dart';
import 'package:x_skill/pages/Photos_page.dart';
import 'package:x_skill/pages/skills_page.dart';
import 'package:x_skill/pages/videos_page.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedIndex = 0;
  List<Widget> get _screens => [
    HomePage(),
    PhotosPage(),
    SkillsPage(),
    VideosPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 640)
            NavigationRail(
              indicatorColor: const Color.fromARGB(255, 186, 186, 186),
              backgroundColor: Colors.white,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedIndex: _selectedIndex,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text("Home"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.photo_library),
                  label: Text("Photos"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.build),
                  label: Text("Skills"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.video_camera_back),
                  label: Text("Videos"),
                ),
              ],
              labelType: NavigationRailLabelType.all,
              selectedLabelTextStyle: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              unselectedLabelTextStyle: const TextStyle(
                color: Color.fromARGB(255, 72, 72, 72),
              ),
              leading: Column(
                children: [
                  Image.asset('assets/images/logo.png', width: 100),
                  SizedBox(height: 4),
                ],
              ),
            ),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width < 640
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              unselectedItemColor: const Color.fromARGB(255, 72, 72, 72),
              selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              backgroundColor: Colors.white,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Skills'),
                BottomNavigationBarItem(icon: Icon(Icons.photo_library), label: 'Photos'),
                BottomNavigationBarItem(icon: Icon(Icons.video_camera_back), label: 'Videos'),
              ],
            )
          : null,
    );
  }
}
