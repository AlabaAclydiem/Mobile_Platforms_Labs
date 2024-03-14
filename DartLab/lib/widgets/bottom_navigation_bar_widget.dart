import 'package:lab2/pages/profile_page.dart';
import 'package:flutter/material.dart';

import '../pages/favorite_page.dart';
import '../pages/main_page.dart';

class CustomBottomNavigationBarWidget extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNavigationBarWidget(
      {super.key, required this.currentIndex});

  @override
  State<CustomBottomNavigationBarWidget> createState() =>
      _CustomBottomNavigationBarWidgetState();
}

class _CustomBottomNavigationBarWidgetState
    extends State<CustomBottomNavigationBarWidget> {
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _loadScreen() {
    switch (_currentIndex) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const FavoritePage()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfilePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
        _loadScreen();
      },
      unselectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}
