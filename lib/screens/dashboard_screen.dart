import 'package:flutter/material.dart';
import '../api/github_service.dart';
import '../models/user_model.dart';
import '../models/repo_model.dart';
import '../utils/constants.dart';
import '../widgets/language_chart.dart';
import '../widgets/liquid_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/sliding_card.dart';
import '../widgets/repo_insight_sheet.dart';

class DashboardScreen extends StatefulWidget {
  final String username;

  const DashboardScreen({super.key, required this.username});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GithubService _githubService = GithubService();
  late Future<User> _userFuture;
  late Future<List<Repo>> _reposFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _githubService.getUser(widget.username);
    _reposFuture = _githubService.getRepos(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.username,
          style: AppTextStyles.header.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: LiquidBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<User>(
                future: _userFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: AppColors.error)));
                  } else if (snapshot.hasData) {
                    return SlidingCard(
                      delay: const Duration(milliseconds: 200),
                      child: _buildUserProfile(snapshot.data!),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 24),
              FutureBuilder<List<Repo>>(
                future: _reposFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryLight));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: AppColors.error)));
                  } else if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SlidingCard(
                          delay: const Duration(milliseconds: 400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Languages', style: AppTextStyles.subHeader),
                              const SizedBox(height: 12),
                              GlassContainer(
                                padding: const EdgeInsets.all(16),
                                child: LanguageChart(repos: snapshot.data!),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text('Repositories', style: AppTextStyles.subHeader),
                        const SizedBox(height: 12),
                        _buildRepoList(snapshot.data!),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile(User user) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name ?? user.login, style: AppTextStyles.header.copyWith(fontSize: 22)),
                    if (user.bio != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        user.bio!,
                        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Repos', user.publicRepos.toString()),
              _buildStatItem('Followers', user.followers.toString()),
              _buildStatItem('Following', user.following.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.header.copyWith(fontSize: 20, color: AppColors.primaryBlue)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildRepoList(List<Repo> repos) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: repos.length,
      itemBuilder: (context, index) {
        final repo = repos[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SlidingCard(
            delay: Duration(milliseconds: index * 100),
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) => RepoInsightSheet(repo: repo),
              );
            },
            child: GlassContainer(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          repo.name,
                          style: AppTextStyles.header.copyWith(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (repo.language != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            repo.language!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (repo.description != null && repo.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      repo.description!,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(repo.stargazersCount.toString(), style: AppTextStyles.caption),
                      const SizedBox(width: 16),
                      const Icon(Icons.call_split_rounded, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(repo.forksCount.toString(), style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
