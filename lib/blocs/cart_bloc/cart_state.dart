part of 'cart_bloc.dart';

class TotalPriceState extends Equatable {
  final num totalPrice;

  const TotalPriceState({required this.totalPrice});

  @override
  List<Object> get props => [totalPrice];
}