import 'package:lab2/utils/game_data.dart';
import 'package:lab2/utils/firebase_auth_service.dart';
import 'package:lab2/utils/user.dart';
import 'package:lab2/utils/util_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDataService {
  static final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref();

  static Future<void> createDatabaseUser(String id, UserData user) async {
    await _databaseReference.child('Users').child(id).set(user.toJson());
  }

  static Future<List<GameData>> getFavoriteGames() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final userDataSnapshot =
        await _databaseReference.child('Users').child(user!.uid).once();
    final data =
        Map<String, dynamic>.from(userDataSnapshot.snapshot.value as Map);
    if (data.containsKey('favs')) {
      if (data['favs'] != null && data['favs'].isNotEmpty) {
        var favoritePosts = data['favs']
            ?.map((key, value) => MapEntry(key as String, value as dynamic));
        List<GameData> books =
            GameData.getGameList(favoritePosts.values.toList());
        return books;
      }
    }
    return [];
  }

  static Future<UserData> getUserData() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final userDataSnapshot =
        await _databaseReference.child('Users').child(user!.uid).once();
    final data =
        Map<String, dynamic>.from(userDataSnapshot.snapshot.value as Map);
    final UserData userData = UserData.fromJson(data);
    return userData;
  }

  static Future<List<GameData>> getAllGames() async {
    final allBooksSnapshot = await _databaseReference.child('Games').once();
    final allData =
        Map<String, dynamic>.from(allBooksSnapshot.snapshot.value as Map);
    final List<GameData> books = GameData.getGameList(allData.values.toList());
    return books;
  }

  static Future<bool> pushFavoriteGameToUser(GameData book) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    try {
      await _databaseReference
          .child('Users')
          .child(user!.uid)
          .child('favs')
          .push()
          .set(book.toJson());
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  static Future<bool> popFavoriteGameFromUser(GameData book) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    try {
      final userDataSnapshot =
          await _databaseReference.child('Users').child(user!.uid).once();
      final data =
          Map<String, dynamic>.from(userDataSnapshot.snapshot.value as Map);
      if (data.containsKey('favs')) {
        var favoritePosts = data['favs'] != null
            ? Map<String, dynamic>.from(data['favs'])
            : <String, dynamic>{};
        favoritePosts.removeWhere((key, value) => book == value);
        await _databaseReference
            .child('Users')
            .child(user.uid)
            .update({'favs': favoritePosts});
        return true;
      }
      return false;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  static Future<bool> checkUserFavoriteGame(GameData book) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final userDataSnapshot =
        await _databaseReference.child('Users').child(user!.uid).once();
    final data =
        Map<String, dynamic>.from(userDataSnapshot.snapshot.value as Map);

    if (data.containsKey('favs')) {
      var favoritePosts = data['favs']
          ?.map((key, value) => MapEntry(key as String, value as dynamic));
      List<GameData> books =
          GameData.getGameList(favoritePosts.values.toList());
      return books.contains(book);
    }
    return false;
  }
}
