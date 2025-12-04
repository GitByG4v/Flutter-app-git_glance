class Repo {
  final String name;
  final String? description;
  final String? language;
  final int stargazersCount;
  final int forksCount;
  final String htmlUrl;
  final DateTime updatedAt;
  final String? licenseName;
  final List<String> topics;
  final int openIssuesCount;
  final int size;

  Repo({
    required this.name,
    this.description,
    this.language,
    required this.stargazersCount,
    required this.forksCount,
    required this.htmlUrl,
    required this.updatedAt,
    this.licenseName,
    required this.topics,
    required this.openIssuesCount,
    required this.size,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'],
      description: json['description'],
      language: json['language'],
      stargazersCount: json['stargazers_count'],
      forksCount: json['forks_count'],
      htmlUrl: json['html_url'],
      updatedAt: DateTime.parse(json['updated_at']),
      licenseName: json['license'] != null ? json['license']['name'] : null,
      topics: List<String>.from(json['topics'] ?? []),
      openIssuesCount: json['open_issues_count'] ?? 0,
      size: json['size'] ?? 0,
    );
  }
}
