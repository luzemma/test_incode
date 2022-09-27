part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final bool acceptTerms;

  const RegisterState({required this.acceptTerms});

  @override
  List<Object> get props => [acceptTerms];
}
