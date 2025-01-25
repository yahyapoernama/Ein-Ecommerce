part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final List<String> errors; // Simpan List of Strings

  const RegisterFailure({this.errors = const []}); // Inisialisasi dengan list kosong

  @override
  List<Object> get props => [errors];
}