class UserData {
  final String email;
  final String name;
  final String surname;
  final String about;
  final num age;
  final String favorite_games;
  final String favorite_genres;
  final List<String>? favorite_posts = [];

  UserData(this.email, this.name, this.surname, this.about, this.age,
      this.favorite_genres, this.favorite_games);

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'surname': surname,
        'about': about,
        'age': age,
        'favorite_games': favorite_games,
        'favorite_genres': favorite_genres,
        'favorite_posts': favorite_posts,
      };

  static UserData fromJson(Map<String, dynamic> data) {
    return UserData(data['email'], data['name'], data['surname'], data['about'],
        data['age'], data['favorite_genres'], data['favorite_games']);
  }
}
