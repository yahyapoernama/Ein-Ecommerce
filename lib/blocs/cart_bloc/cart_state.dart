part of 'cart_bloc.dart';

class TotalPriceState extends Equatable {
  final num totalPrice;

  const TotalPriceState({required this.totalPrice});

  @override
  List<Object> get props => [totalPrice];
}

class CartItemsState extends Equatable {
  final List<Map<String, dynamic>> cartItems;

  const CartItemsState({required this.cartItems});

  @override
  List<Object> get props => [cartItems];
}

class CartItemsInitial extends CartItemsState {
  CartItemsInitial()
      : super(
            cartItems: List.generate(10, (index) {
          return {
            'name': 'Product Name',
            'price': 100000,
            'quantity': 100,
            'isChecked': false,
          };
        }));
}

class CartItemsLoaded extends CartItemsState {
  CartItemsLoaded()
      : super(cartItems: [
          {
            'name': 'Product 1',
            'price': 50000,
            'quantity': 2,
            'isChecked': false,
          },
          {
            'name': 'Product 2',
            'price': 50000,
            'quantity': 1,
            'isChecked': false,
          },
          {
            'name': 'Product 3',
            'price': 50000,
            'quantity': 1,
            'isChecked': false,
          },
        ]);
}