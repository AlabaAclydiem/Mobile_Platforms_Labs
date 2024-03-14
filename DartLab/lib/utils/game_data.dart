class GameData {
  late String id;
  late String description;
  late String title;
  late List<String> images;

  GameData(this.id, this.title, this.description, this.images);

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'images': images,
        'title': title,
      };

  static getGameList(List data) {
    List<GameData> result = [];
    for (final game in data) {
      List<String> images =
          (game['images'] as List).map((e) => e as String).toList();
      result.add(
          GameData(game['id'], game['title'], game['description'], images));
    }
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is GameData) {
      return other.id == id;
    } else if (other is Map<Object?, Object?>) {
      Map<String, dynamic> temp =
          other.map((key, value) => MapEntry(key.toString(), value));
      return temp['id'] == id;
    }

    return false;
  }

  @override
  int get hashCode => title.hashCode;
}
