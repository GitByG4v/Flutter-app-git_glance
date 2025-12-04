import 'package:flutter/material.dart';
import '../models/roadmap_model.dart';
import '../utils/constants.dart';
import '../widgets/liquid_background.dart';
import '../widgets/roadmap_card.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Learn', style: AppTextStyles.header),
        centerTitle: true,
      ),
      body: LiquidBackground(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
          itemCount: roadmaps.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: RoadmapCard(
                roadmap: roadmaps[index],
                delay: Duration(milliseconds: index * 100),
              ),
            );
          },
        ),
      ),
    );
  }
}
