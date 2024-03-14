import 'package:lab2/utils/game_data.dart';
import 'package:lab2/utils/firebase_data_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lab2/widgets/slider.dart';


class GameDetails extends StatefulWidget {
  final String title;
  final GameData game;

  const GameDetails({super.key, required this.title, required this.game});

  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {
  bool _isPushing = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _getFavoriteStatus();
  }

  Widget gameWidget(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Container(
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).colorScheme.tertiary,
            width: 1.0,
          ),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
              child: Text(
                widget.game.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
              child: Text(
                'Description: ${widget.game.description}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
      CarouselExample(images: widget.game.images),
      GestureDetector(
        onTap: () {
          _pushToFavorite();
        },
        child: Container(
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: _isPushing
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
                : Text(
                    _isFavorite ? 'Delete From Favorites' : 'Set to Favorites',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        centerTitle: true,
      ),
      body: gameWidget(context),
    );
  }

  void _pushToFavorite() async {
    setState(() {
      _isPushing = true;
    });
    bool res = false;
    if (_isFavorite) {
      res = await FirebaseDataService.popFavoriteGameFromUser(widget.game);
    } else {
      res = await FirebaseDataService.pushFavoriteGameToUser(widget.game);
    }
    _getFavoriteStatus();

    setState(() {
      _isPushing = false;
    });
  }

  void _getFavoriteStatus() async {
    bool res = await FirebaseDataService.checkUserFavoriteGame(widget.game);
    if (res) {
      setState(() {
        _isFavorite = true;
      });
    } else {
      setState(() {
        _isFavorite = false;
      });
    }
  }
}
