import 'package:lab2/utils/game_data.dart';
import 'package:lab2/utils/firebase_data_service.dart';
import 'package:lab2/widgets/app_bar.dart';
import 'package:lab2/widgets/bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';

import 'game_details.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget gamesWidget() {
    return FutureBuilder(
      future: FirebaseDataService.getAllGames(),
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
    List<GameData> values = snapshot.data;
    if (values.isEmpty) {
      return const Text('Empty Data');
    }
    return ListView.builder(
      itemCount: values.length,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  width: 1.0,
                ),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              alignment: const AlignmentDirectional(0, 0),
              child: ListTile(
                leading: Icon(
                  Icons.games,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                title: Text(
                  values[index].title ?? 'No Data',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 20,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GameDetails(
                              title: values[index].title,
                              game: values[index])));
                },
                contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(5, 20, 5, 20),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Game List'),
      body: gamesWidget(),
      bottomNavigationBar:
          const CustomBottomNavigationBarWidget(currentIndex: 0),
    );
  }
}
