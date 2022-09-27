import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(const RegisterState(acceptTerms: false)) {
    on<AcceptTerms>((event, emit) {
      emit(RegisterState(acceptTerms: event.acceptTerms));
    });
  }
}
