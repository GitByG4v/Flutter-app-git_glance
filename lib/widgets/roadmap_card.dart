import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/roadmap_model.dart';
import '../utils/constants.dart';
import 'glass_container.dart';
import 'sliding_card.dart';

class RoadmapCard extends StatelessWidget {
  final Roadmap roadmap;
  final Duration delay;

  const RoadmapCard({super.key, required this.roadmap, required this.delay});

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(roadmap.url);
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
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color(int.parse(roadmap.colorHex)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  roadmap.iconPath,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roadmap.title,
                    style: AppTextStyles.header.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    roadmap.description,
                    style: AppTextStyles.caption.copyWith(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
