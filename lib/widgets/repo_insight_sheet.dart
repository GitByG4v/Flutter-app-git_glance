import 'package:flutter/material.dart';
import '../models/repo_model.dart';
import '../utils/constants.dart';
import 'glass_container.dart';

class RepoInsightSheet extends StatelessWidget {
  final Repo repo;

  const RepoInsightSheet({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final analysis = _analyzeRepo(repo);
    final healthScore = analysis['score'] as int;
    final goodThings = analysis['good'] as List<String>;
    final gaps = analysis['gaps'] as List<String>;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Repo Insight', style: AppTextStyles.header.copyWith(fontSize: 20)),
                    const SizedBox(height: 4),
                    Text(repo.name, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _getScoreColor(healthScore).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Score: $healthScore/100',
                  style: AppTextStyles.header.copyWith(
                    fontSize: 16,
                    color: _getScoreColor(healthScore),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildSection('Good Things', goodThings, Colors.green),
          const SizedBox(height: 24),
          _buildSection('Gaps & Flaws', gaps, Colors.orange),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.subHeader.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (items.isEmpty)
          Text('None detected.', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary))
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      title == 'Good Things' ? Icons.check_circle : Icons.warning,
                      size: 14,
                      color: color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item,
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }

  Map<String, dynamic> _analyzeRepo(Repo repo) {
    int score = 0;
    List<String> good = [];
    List<String> gaps = [];

    // 1. Popularity (10 pts) - Stars & Forks
    if (repo.stargazersCount > 100 || repo.forksCount > 20) {
      score += 10;
      good.add('High Popularity');
    } else if (repo.stargazersCount > 10) {
      score += 5;
      good.add('Growing Interest');
    } else {
      // No penalty, just no points
    }

    // 2. Maintenance (10 pts) - Recency & Issues
    final daysSinceUpdate = DateTime.now().difference(repo.updatedAt).inDays;
    if (daysSinceUpdate < 180) { // Updated in last 6 months
      score += 5;
      good.add('Recently Updated');
    } else {
      gaps.add('Inactive (> 6 months)');
    }

    if (repo.openIssuesCount < 50) {
      score += 5;
      good.add('Issues Managed');
    } else {
      gaps.add('High Issue Count');
    }

    // 3. Structure (40 pts) - License, Description, Topics
    if (repo.licenseName != null) {
      score += 15;
      good.add('Licensed (${repo.licenseName})');
    } else {
      gaps.add('Missing License');
    }

    if (repo.description != null && repo.description!.length > 10) {
      score += 15;
      good.add('Good Description');
    } else {
      gaps.add('Poor/Missing Description');
    }

    if (repo.topics.isNotEmpty) {
      score += 10;
      good.add('Topics Added');
    } else {
      gaps.add('No Topics');
    }

    // 4. Health/Size (40 pts) - Size & Language
    if (repo.size > 100) { // > 100KB implies some content
      score += 20;
      good.add('Substantial Content');
    } else {
      gaps.add('Empty/Small Repo');
    }

    if (repo.language != null) {
      score += 20;
      good.add('Language Defined');
    } else {
      gaps.add('Language Not Set');
    }

    return {'score': score, 'good': good, 'gaps': gaps};
  }
}
