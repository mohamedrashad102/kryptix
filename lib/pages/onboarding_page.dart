import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/password_generator_cubit.dart';
import '../l10n/app_localizations.dart';
import 'home_page.dart';

/// A page that introduces new users to the application.
class OnboardingPage extends StatefulWidget {
  /// Creates an [OnboardingPage].
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onFinish() {
    // Mark as finished in storage
    unawaited(context.read<PasswordGeneratorCubit>().completeOnboarding());

    // Navigate to home and replace
    unawaited(
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (context) => const HomePage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final slides = [
      _OnboardingSlide(
        title: l10n.onboarding1Title,
        subtitle: l10n.onboarding1Subtitle,
        image: 'assets/images/onboarding_1.png',
      ),
      _OnboardingSlide(
        title: l10n.onboarding2Title,
        subtitle: l10n.onboarding2Subtitle,
        image: 'assets/images/onboarding_2.png',
      ),
      _OnboardingSlide(
        title: l10n.onboarding3Title,
        subtitle: l10n.onboarding3Subtitle,
        image: 'assets/images/onboarding_3.png',
      ),
    ];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _onFinish,
                child: Text(
                  l10n.skip,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return slides[index];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      slides.length,
                      (index) => _DotIndicator(isActive: _currentPage == index),
                    ),
                  ),
                  if (_currentPage == slides.length - 1)
                    FilledButton(
                      onPressed: _onFinish,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(l10n.getStarted),
                    )
                  else
                    IconButton.filled(
                      onPressed: () {
                        unawaited(
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward_rounded),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 300,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Icon(
                  Icons.image_rounded,
                  size: 64,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.3),
                ),
              );
            },
          ),
          const SizedBox(height: 60),
          Text(
            title,
            textAlign: Alignment.center == Alignment.center
                ? TextAlign.center
                : TextAlign.start,
            style: const TextStyle(
              fontFamily: 'Jost',
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface.withValues(
                alpha: 0.6,
              ),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
