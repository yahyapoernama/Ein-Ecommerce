part of 'app_connection_bloc.dart';

sealed class AppConnectionState extends Equatable {
  const AppConnectionState();
  
  @override
  List<Object> get props => [];
}

final class AppConnectionInitial extends AppConnectionState {}

class AppConnectionLoading extends AppConnectionState {}

class NoInternetState extends AppConnectionState {
  final String message;
  const NoInternetState({
    this.message = 'No Internet Connection',
  });
}

class ServerUnreachableState extends AppConnectionState {
  final String message;
  const ServerUnreachableState({
    this.message = 'Server Unreachable',
  });
}

class ConnectedState extends AppConnectionState {}

class UnknownErrorState extends AppConnectionState {
  final String message;
  const UnknownErrorState({
    this.message = 'Unknown Error',
  });
}
