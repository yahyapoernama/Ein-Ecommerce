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

abstract class CartItemsEvent extends Equatable {
  final List<Map<String, dynamic>> cartItems;
  
  const CartItemsEvent(this.cartItems);

  @override
  List<Object> get props => [cartItems];
}

class InitialCartItems extends CartItemsEvent {
  const InitialCartItems(super.cartItems);
}

class LoadCartItems extends CartItemsEvent {
  const LoadCartItems(super.cartItems);
}