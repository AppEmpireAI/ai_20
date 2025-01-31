import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ai_20/core/bloc/onboarding_bloc.dart';
import 'package:ai_20/core/constants/theme/app_theme.dart';
import 'package:ai_20/core/constants/svgs/onboarding_svgs.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showGetStarted = false;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      svg: OnboardingSVGs.welcomeSVG,
      title: 'Welcome to My Green Corner',
      description: 'Your personal plant care companion. Let\'s grow together!',
    ),
    OnboardingPage(
      svg: OnboardingSVGs.identifySVG,
      title: 'Identify Plants',
      description:
          'Take a photo to identify your plants and get care recommendations.',
    ),
    OnboardingPage(
      svg: OnboardingSVGs.careGuideSVG,
      title: 'Care Guide',
      description:
          'Get personalized care instructions for each of your plants.',
    ),
    OnboardingPage(
      svg: OnboardingSVGs.remindersSVG,
      title: 'Smart Reminders',
      description: 'Never forget to water or care for your plants again.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final page = _pageController.page ?? 0;
    setState(() {
      _currentPage = page.round();
      _showGetStarted = page >= _pages.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.string(
            page.svg,
            height: 300,
          ).animate().fadeIn(duration: AppTheme.animationNormal).scale(
                begin: const Offset(0.8, 0.8),
                duration: AppTheme.animationNormal,
              ),
          const SizedBox(height: AppTheme.paddingLarge),
          Text(
            page.title,
            style: AppTheme.headlineLarge.copyWith(
              color: AppTheme.primaryGreen,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(
                duration: AppTheme.animationNormal,
                delay: 200.milliseconds,
              )
              .slideY(
                begin: 0.2,
                duration: AppTheme.animationNormal,
              ),
          const SizedBox(height: AppTheme.paddingMedium),
          Text(
            page.description,
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.textMedium,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(
                duration: AppTheme.animationNormal,
                delay: 400.milliseconds,
              )
              .slideY(
                begin: 0.2,
                duration: AppTheme.animationNormal,
              ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => AnimatedContainer(
                duration: AppTheme.animationNormal,
                margin: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppTheme.primaryGreen
                      : AppTheme.lightGreen,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          AnimatedCrossFade(
            duration: AppTheme.animationNormal,
            crossFadeState: _showGetStarted
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  onPressed: () => _completeOnboarding(context),
                  child: const Text('Skip'),
                ),
                CupertinoButton.filled(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: AppTheme.animationNormal,
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
            secondChild: SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                onPressed: () => _completeOnboarding(context),
                child: const Text('Get Started'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _completeOnboarding(BuildContext context) {
    context.read<OnboardingBloc>().add(CompleteOnboarding());
  }
}

class OnboardingPage {
  final String svg;
  final String title;
  final String description;

  const OnboardingPage({
    required this.svg,
    required this.title,
    required this.description,
  });
}
