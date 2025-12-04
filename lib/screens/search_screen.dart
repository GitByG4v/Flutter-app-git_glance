import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/liquid_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/sliding_card.dart';
import 'dashboard_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  void _search() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    // Smooth transition delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isSearching = false;
      });
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
            DashboardScreen(username: _controller.text),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlidingCard(
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      children: [
                        Icon(
                          Icons.code,
                          size: 64,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'GitGlance',
                          style: AppTextStyles.header,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Discover GitHub Profiles',
                          style: AppTextStyles.subHeader,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  SlidingCard(
                    delay: const Duration(milliseconds: 400),
                    child: GlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: AppTextStyles.body.copyWith(fontSize: 16),
                              decoration: InputDecoration(
                                hintText: 'Enter username...',
                                hintStyle: AppTextStyles.caption.copyWith(fontSize: 16),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _search(),
                            ),
                          ),
                          if (_isSearching)
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryBlue,
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: _search,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
