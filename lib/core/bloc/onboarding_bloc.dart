import 'package:hive/hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_20/core/models/onboarding_state.dart';

abstract class OnboardingEvent {}

class CompleteOnboarding extends OnboardingEvent {}

class CheckOnboardingStatus extends OnboardingEvent {}

abstract class OnboardingStatus {
  const OnboardingStatus();
}

class OnboardingInitial extends OnboardingStatus {}

class OnboardingRequired extends OnboardingStatus {}

class OnboardingCompleted extends OnboardingStatus {}

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingStatus> {
  final Box<OnboardingState> onboardingBox;

  OnboardingBloc({required this.onboardingBox}) : super(OnboardingInitial()) {
    on<CheckOnboardingStatus>(_onCheckOnboardingStatus);
    on<CompleteOnboarding>(_onCompleteOnboarding);
  }

  Future<void> _onCheckOnboardingStatus(
    CheckOnboardingStatus event,
    Emitter<OnboardingStatus> emit,
  ) async {
    final state = onboardingBox.get('onboarding');
    if (state?.hasCompletedOnboarding ?? false) {
      emit(OnboardingCompleted());
    } else {
      emit(OnboardingRequired());
    }
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboarding event,
    Emitter<OnboardingStatus> emit,
  ) async {
    await onboardingBox.put(
      'onboarding',
      OnboardingState(hasCompletedOnboarding: true),
    );
    emit(OnboardingCompleted());
  }
}
