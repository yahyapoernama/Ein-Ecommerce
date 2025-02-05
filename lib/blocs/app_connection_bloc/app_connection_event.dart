part of 'app_connection_bloc.dart';

abstract class AppConnectionEvent extends Equatable {
  const AppConnectionEvent();

  @override
  List<Object> get props => [];
}

class CheckAppConnectionEvent extends AppConnectionEvent {}