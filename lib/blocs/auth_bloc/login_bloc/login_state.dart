part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final List<String> errors; // Simpan List of Strings

  const LoginFailure({this.errors = const []}); // Inisialisasi dengan list kosong

  @override
  List<Object> get props => [errors];
}