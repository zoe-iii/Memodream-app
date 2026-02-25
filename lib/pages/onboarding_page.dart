import 'package:flutter/material.dart';
import 'page1.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      'icon': Icons.nights_stay,
      'title': '记录梦境',
      'description': '每天早晨，用语音或文字记录下你的梦境，保留那些转瞬即逝的灵感与情绪',
      'color': const Color(0xFF6C63FF),
    },
    {
      'icon': Icons.auto_graph,
      'title': '智能分析',
      'description': 'AI深度解析梦境模式，发现你潜意识中的情绪趋势与心理需求',
      'color': const Color(0xFF00D9FF),
    },
    {
      'icon': Icons.spa,
      'title': '睡眠优化',
      'description': '基于睡眠数据与梦境质量，为你定制专属的助眠方案与睡前引导',
      'color': const Color(0xFF9D4EDD),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _enterApp();
    }
  }

  void _enterApp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(), // Page1的类名是HomePage
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _enterApp,
                  child: Text(
                    '跳过',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  final data = onboardingData[index];
                  return _buildPage(
                    icon: data['icon'] as IconData,
                    title: data['title'] as String,
                    description: data['description'] as String,
                    color: data['color'] as Color,
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color(0xFF6C63FF)
                          : Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: GestureDetector(
                onTap: _nextPage,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _currentPage == onboardingData.length - 1
                          ? [const Color(0xFF6C63FF), const Color(0xFF00D9FF)]
                          : [
                              Colors.white.withValues(alpha: 0.1),
                              Colors.white.withValues(alpha: 0.1),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _currentPage == onboardingData.length - 1
                          ? Colors.transparent
                          : Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _currentPage == onboardingData.length - 1
                          ? '开启梦境之旅'
                          : '下一步',
                      style: TextStyle(
                        color: _currentPage == onboardingData.length - 1
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.8),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  color.withValues(alpha: 0.3),
                  color.withValues(alpha: 0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 100, color: color),
          ),

          const SizedBox(height: 60),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
