import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/repo_model.dart';
import '../utils/constants.dart';
import 'glass_container.dart';
import 'sliding_card.dart';

class ProjectCard extends StatelessWidget {
  final Repo repo;
  final Duration delay;

  const ProjectCard({super.key, required this.repo, required this.delay});

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(repo.htmlUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlidingCard(
      delay: delay,
      onTap: _launchUrl,
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      repo.name[0].toUpperCase(),
                      style: AppTextStyles.header.copyWith(
                        fontSize: 20,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        repo.name,
                        style: AppTextStyles.header.copyWith(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        repo.language ?? 'Unknown',
                        style: AppTextStyles.caption.copyWith(color: AppColors.primaryLight),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(_formatNumber(repo.stargazersCount), style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (repo.description != null) ...[
              Text(
                repo.description!,
                style: AppTextStyles.body.copyWith(fontSize: 12, color: AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Updated ${_formatDate(repo.updatedAt)}',
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),
                const Icon(Icons.arrow_forward, size: 16, color: AppColors.primaryBlue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else {
      return 'Today';
    }
  }
}
