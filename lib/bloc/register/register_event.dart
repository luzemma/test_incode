part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {}

class AcceptTerms extends RegisterEvent {
  final bool acceptTerms;

  AcceptTerms(this.acceptTerms);

  @override
  List<Object> get props => [acceptTerms];
}
