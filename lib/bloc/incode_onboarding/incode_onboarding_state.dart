part of 'incode_onboarding_bloc.dart';

class IncodeOnboardingState extends Equatable {
  final IncodeSdkStatus status;
  final String? completedSection;
  final String? error;
  final String? userScore;
  final String? interviewId;


  const IncodeOnboardingState({ required this.status, this.completedSection, this.error, this.userScore, this.interviewId });
  
  @override
  List<Object?> get props => [status, completedSection, error, userScore, interviewId];
}