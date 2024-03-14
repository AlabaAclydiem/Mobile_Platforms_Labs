import 'package:lab2/utils/firebase_data_service.dart';
import 'package:lab2/utils/user.dart';
import 'package:lab2/widgets/app_bar.dart';
import 'package:lab2/widgets/profile_label.dart';
import 'package:flutter/material.dart';

import '../widgets/bottom_navigation_bar_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _profileInfoWidget() {
    return FutureBuilder(
      future: FirebaseDataService.getUserData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Text('Loading...');
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return createListView(context, snapshot);
            }
        }
      },
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    UserData userData = snapshot.data;
    if (userData.toString().isEmpty) {
      return const Text('Nothing is here');
    }
    return ListView(
      children: [
        ProfileSection(text: userData.email, currentIndex: 0),
        ProfileSection(text: userData.name, currentIndex: 1),
        ProfileSection(text: userData.surname, currentIndex: 2),
        ProfileSection(text: userData.about, currentIndex: 3),
        ProfileSection(text: userData.age.toString(), currentIndex: 4),
        ProfileSection(text: userData.favorite_games, currentIndex: 5),
        ProfileSection(text: userData.favorite_genres, currentIndex: 6),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile Page'),
      body: _profileInfoWidget(),
      bottomNavigationBar:
          const CustomBottomNavigationBarWidget(currentIndex: 2),
    );
  }
}
