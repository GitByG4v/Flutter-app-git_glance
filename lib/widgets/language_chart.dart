import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/repo_model.dart';

class LanguageChart extends StatelessWidget {
  final List<Repo> repos;

  const LanguageChart({super.key, required this.repos});

  @override
  Widget build(BuildContext context) {
    final Map<String, int> languageCounts = {};
    for (var repo in repos) {
      if (repo.language != null) {
        languageCounts[repo.language!] = (languageCounts[repo.language!] ?? 0) + 1;
      }
    }

    if (languageCounts.isEmpty) {
      return const SizedBox();
    }

    final List<PieChartSectionData> sections = languageCounts.entries.map((entry) {
      final isLarge = entry.value > (repos.length / 5);
      return PieChartSectionData(
        color: _getColorForLanguage(entry.key),
        value: entry.value.toDouble(),
        title: entry.key,
        radius: isLarge ? 60 : 50,
        titleStyle: AppTextStyles.caption.copyWith(
          fontSize: isLarge ? 12 : 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }

  Color _getColorForLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'dart':
        return AppColors.primaryBlue;
      case 'python':
        return Colors.blueAccent;
      case 'javascript':
        return Colors.amber;
      case 'html':
        return Colors.orange;
      case 'css':
        return Colors.lightBlue;
      case 'java':
        return Colors.redAccent;
      default:
        return AppColors.primaryLight;
    }
  }
}
