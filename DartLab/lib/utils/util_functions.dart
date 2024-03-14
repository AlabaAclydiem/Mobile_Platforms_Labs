import 'package:lab2/utils/game_data.dart';

class UtilFunctions {
  static checkListType(List list) {
    if (list.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static findElement(List<GameData> list, GameData element) {
    for (final book in list) {
      if (book.title == element.title) {
        return true;
      }
    }
    return false;
  }
}
