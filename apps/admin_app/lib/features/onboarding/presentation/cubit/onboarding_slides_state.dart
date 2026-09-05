import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

sealed class OnboardingSlidesState extends Equatable {
  const OnboardingSlidesState();

  @override
  List<Object?> get props => [];
}

class OnboardingSlidesInitial extends OnboardingSlidesState {
  const OnboardingSlidesInitial();
}

class OnboardingSlidesLoading extends OnboardingSlidesState {
  const OnboardingSlidesLoading();
}

class OnboardingSlidesLoaded extends OnboardingSlidesState {
  final List<OnboardingSlideEntity> slides;

  const OnboardingSlidesLoaded(this.slides);

  @override
  List<Object?> get props => [slides];
}

class OnboardingSlidesError extends OnboardingSlidesState {
  final String message;
  const OnboardingSlidesError(this.message);

  @override
  List<Object?> get props => [message];
}
