part of 'incode_onboarding_bloc.dart';

abstract class IncodeOnboardingEvent extends Equatable {}

class ChangeStatusIncodeOnboarding extends IncodeOnboardingEvent {
  final IncodeSdkStatus status;
  final String? interviewId;

  ChangeStatusIncodeOnboarding({ required this.status, this.interviewId });

  @override
  List<Object?> get props => [status];
}

class CompleteIncodeOnboardingSection extends IncodeOnboardingEvent {
  final String? completedSection; 

  CompleteIncodeOnboardingSection({ required this.completedSection });

  @override
  List<Object?> get props => [completedSection];
}

class OnErrorIncodeOnboardingSection extends IncodeOnboardingEvent {
  final IncodeSdkStatus status;
  final String? error; 

  OnErrorIncodeOnboardingSection({ required this.status, required this.error });

  @override
  List<Object?> get props => [status, error];
}

class FinishIncodeOnboarding extends IncodeOnboardingEvent {
  final IncodeSdkStatus status;
  final String userScore;
  final DtoIncodeData? data;

  FinishIncodeOnboarding({ required this.status, required this.userScore, required this.data });

  @override
  List<Object?> get props => [status, userScore, data];

}