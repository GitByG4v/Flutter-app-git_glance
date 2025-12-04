import 'package:flutter/material.dart';
import '../api/github_service.dart';
import '../models/repo_model.dart';
import '../utils/constants.dart';
import '../widgets/liquid_background.dart';
import '../widgets/project_card.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final GithubService _githubService = GithubService();
  late Future<List<Repo>> _trendingReposFuture;

  @override
  void initState() {
    super.initState();
    _trendingReposFuture = _githubService.getTrendingRepos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Discover', style: AppTextStyles.header),
        centerTitle: true,
      ),
      body: LiquidBackground(
        child: FutureBuilder<List<Repo>>(
          future: _trendingReposFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error loading trending projects.\nCheck your internet connection.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(color: AppColors.error),
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              final repos = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                itemCount: repos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ProjectCard(
                      repo: repos[index],
                      delay: Duration(milliseconds: index * 100),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
