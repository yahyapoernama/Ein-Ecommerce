part of 'app_connection_bloc.dart';

sealed class AppConnectionState extends Equatable {
  const AppConnectionState();
  
  @override
  List<Object> get props => [];

  get message => null;
}

final class AppConnectionInitial extends AppConnectionState {}

class AppConnectionLoading extends AppConnectionState {}

class NoInternetState extends AppConnectionState {
  @override
  final String message;
  const NoInternetState({
    this.message = 'No Internet Connection',
  });
}

class ServerUnreachableState extends AppConnectionState {
  @override
  final String message;
  const ServerUnreachableState({
    this.message = 'Service Unavailable',
  });
}

class ConnectedState extends AppConnectionState {}

class UnknownErrorState extends AppConnectionState {
  @override
  final String message;
  const UnknownErrorState({
    this.message = 'Internal Server Error',
  });
}