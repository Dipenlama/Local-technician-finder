import 'package:flutter/material.dart';
import 'package:mistrix/core/widgets/mistrix_logo.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingData(
      icon: Icons.search_rounded,
      title: 'Find the right expert',
      description:
          'Discover verified technicians near you for every repair and maintenance need.',
      accent: Color(0xFF3157D5),
    ),
    _OnboardingData(
      icon: Icons.verified_user_rounded,
      title: 'Trusted and verified',
      description:
          'Compare ratings, skills, availability, and real customer reviews with confidence.',
      accent: Color(0xFF0F9D7A),
    ),
    _OnboardingData(
      icon: Icons.calendar_month_rounded,
      title: 'Book in a few taps',
      description:
          'Choose a convenient time, track your booking, and get the job done without hassle.',
      accent: Color(0xFFFF8B3D),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MistrixLogo(compact: true),
                  TextButton(
                    onPressed: widget.onFinished,
                    child: const Text('Skip'),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  itemBuilder: (context, index) =>
                      _OnboardingSlide(data: _pages[index]),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: index == _currentPage ? 26 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: index == _currentPage
                          ? Theme.of(context).colorScheme.primary
                          : const Color(0xFFD8DCE8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: _next,
                child: Text(_currentPage == _pages.length - 1
                    ? 'Get started'
                    : 'Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _next() {
    if (_currentPage == _pages.length - 1) {
      widget.onFinished();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.data});

  final _OnboardingData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 230,
          height: 230,
          decoration: BoxDecoration(
            color: data.accent.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 142,
              height: 142,
              decoration: BoxDecoration(
                color: data.accent,
                borderRadius: BorderRadius.circular(44),
                boxShadow: [
                  BoxShadow(
                    color: data.accent.withValues(alpha: 0.28),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Icon(data.icon, color: Colors.white, size: 70),
            ),
          ),
        ),
        const SizedBox(height: 48),
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
              ),
        ),
        const SizedBox(height: 14),
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.blueGrey.shade600,
                height: 1.5,
              ),
        ),
      ],
    );
  }
}

class _OnboardingData {
  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color accent;
}
