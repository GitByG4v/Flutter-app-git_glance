class User {
  final String login;
  final String avatarUrl;
  final int publicRepos;
  final int followers;
  final int following;
  final String? name;
  final String? bio;

  User({
    required this.login,
    required this.avatarUrl,
    required this.publicRepos,
    required this.followers,
    required this.following,
    this.name,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['login'],
      avatarUrl: json['avatar_url'],
      publicRepos: json['public_repos'],
      followers: json['followers'],
      following: json['following'],
      name: json['name'],
      bio: json['bio'],
    );
  }
}
