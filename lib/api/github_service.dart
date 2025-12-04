import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/repo_model.dart';


class GithubService {
  static const String baseUrl = 'https://api.github.com';

  Future<User> getUser(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$username'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<Repo>> getRepos(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$username/repos'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Repo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load repos');
    }
  }


  Future<List<Repo>> getTrendingRepos() async {
    // Fetch repos with >1000 stars, sorted by stars
    final response = await http.get(Uri.parse('$baseUrl/search/repositories?q=stars:>1000&sort=stars&order=desc'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> items = data['items'];
      return items.map((json) => Repo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trending repos');
    }
  }
}
