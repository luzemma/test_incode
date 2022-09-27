import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_incode/entities/dto_incode_data.dart';
import 'package:test_incode/enum/incode_status.dart';
import 'package:test_incode/repositories/preferences_repository.dart';

part 'incode_onboarding_event.dart';
part 'incode_onboarding_state.dart';

class IncodeOnboardingBloc extends Bloc<IncodeOnboardingEvent, IncodeOnboardingState> {
  final PreferencesRepository _preferencesRepository;

  IncodeOnboardingBloc({ 
    required PreferencesRepository preferencesRepository }) 
  : _preferencesRepository = preferencesRepository,
  super( const IncodeOnboardingState(status: IncodeSdkStatus.initializing) ) {

    
    on<ChangeStatusIncodeOnboarding>(((event, emit) async {
      if (event.status == IncodeSdkStatus.initialized) {
        final interviewId = await _preferencesRepository.incodeInterviewId;
        emit(IncodeOnboardingState(status: event.status, interviewId: interviewId));
      }
      if (event.status == IncodeSdkStatus.started) {
        if (event.interviewId != null) {
          await _preferencesRepository.saveIncodeInterviewId(event.interviewId!);
        }
        emit(IncodeOnboardingState(status: event.status));
      }
    }));

    on<CompleteIncodeOnboardingSection>((event, emit) {
      if (state.status == IncodeSdkStatus.failure && state.error != null) {
        emit(IncodeOnboardingState(status: state.status, error: state.error, completedSection: event.completedSection));  
      } else {
        emit(IncodeOnboardingState(status: state.status, completedSection: event.completedSection));
      }
    });
    
    on<OnErrorIncodeOnboardingSection>((event, emit) {
      emit(IncodeOnboardingState(status: event.status, error: event.error));
    });
    
    on<FinishIncodeOnboarding>((event, emit) {
      if (event.data != null && event.userScore == "ok") {
        _preferencesRepository.saveIncodeInterviewId(null); // remove it
        emit(IncodeOnboardingState(status: event.status, userScore: event.userScore));
      } else {
        final String error = "There was errors in your KYC validation \\nYour score was ${event.userScore}";
        emit(IncodeOnboardingState(status: IncodeSdkStatus.failure, error: error));
      }
    });
  }
}
