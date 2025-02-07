part of 'cart_bloc.dart';

abstract class TotalPriceEvent extends Equatable {
  const TotalPriceEvent();

  @override
  List<Object> get props => [];
}

class FetchTotalPrice extends TotalPriceEvent {
  final List<Map<String, dynamic>> cartItems;

  const FetchTotalPrice(this.cartItems);
}

class UpdateTotalPrice extends TotalPriceEvent {
  final double totalPrice;

  const UpdateTotalPrice(this.totalPrice);
}

class ResetTotalPrice extends TotalPriceEvent {}

abstract class CheckItemEvent extends Equatable {
  const CheckItemEvent();

  @override
  List<Object> get props => [];
}