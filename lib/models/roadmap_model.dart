class Roadmap {
  final String title;
  final String description;
  final String url;
  final String iconPath; // Using emoji for simplicity or asset path
  final String colorHex;

  Roadmap({
    required this.title,
    required this.description,
    required this.url,
    required this.iconPath,
    required this.colorHex,
  });
}

final List<Roadmap> roadmaps = [
  Roadmap(
    title: 'Flutter Developer',
    description: 'Step by step guide to becoming a Flutter developer in 2024.',
    url: 'https://roadmap.sh/flutter',
    iconPath: '💙',
    colorHex: '0xFF02569B',
  ),
  Roadmap(
    title: 'Frontend Developer',
    description: 'Everything you need to know to become a modern frontend developer.',
    url: 'https://roadmap.sh/frontend',
    iconPath: '🎨',
    colorHex: '0xFFFFD600',
  ),
  Roadmap(
    title: 'Backend Developer',
    description: 'Essential guide to becoming a backend developer.',
    url: 'https://roadmap.sh/backend',
    iconPath: '⚙️',
    colorHex: '0xFF333333',
  ),
  Roadmap(
    title: 'Python Developer',
    description: 'Roadmap to becoming a Python developer.',
    url: 'https://roadmap.sh/python',
    iconPath: '🐍',
    colorHex: '0xFF3776AB',
  ),
  Roadmap(
    title: 'AI & Data Scientist',
    description: 'Step by step guide to becoming an AI and Data Scientist.',
    url: 'https://roadmap.sh/ai-data-scientist',
    iconPath: '🤖',
    colorHex: '0xFF8E44AD',
  ),
];
