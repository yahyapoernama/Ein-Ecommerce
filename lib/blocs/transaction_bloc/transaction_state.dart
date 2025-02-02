part of 'transaction_bloc.dart';

sealed class TransactionState extends Equatable {
  const TransactionState();
  
  @override
  List<Object> get props => [];
}

final class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {}

class TransactionSuccess extends TransactionState {}

class TransactionFailure extends TransactionState {}