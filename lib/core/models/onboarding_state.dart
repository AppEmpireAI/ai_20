import 'package:hive/hive.dart';

part 'onboarding_state.g.dart';

@HiveType(typeId: 3)
class OnboardingState {
  @HiveField(0)
  final bool hasCompletedOnboarding;

  const OnboardingState({
    this.hasCompletedOnboarding = false,
  });

  OnboardingState copyWith({
    bool? hasCompletedOnboarding,
  }) {
    return OnboardingState(
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }
}
