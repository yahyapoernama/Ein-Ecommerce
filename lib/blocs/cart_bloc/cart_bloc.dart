import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class TotalPriceBloc extends Bloc<TotalPriceEvent, TotalPriceState> {
  TotalPriceBloc() : super(const TotalPriceState(totalPrice: 0)) {
    on<UpdateTotalPrice>(_onUpdateTotalPrice);
    on<ResetTotalPrice>(_onResetTotalPrice);
  }

  void _onUpdateTotalPrice(
    UpdateTotalPrice event,
    Emitter<TotalPriceState> emit,
  ) {
    emit(
      TotalPriceState(
        totalPrice: (state.totalPrice + event.totalPrice).toDouble(),
      ),
    );
  }

  void _onResetTotalPrice(
    ResetTotalPrice event,
    Emitter<TotalPriceState> emit,
  ) {
    emit(const TotalPriceState(totalPrice: 0));
  }
}

class CartItemsBloc extends Bloc<CartItemsEvent, CartItemsState> {
  CartItemsBloc() : super(CartItemsInitial()) {
    on<InitialCartItems>(_onInitialCartItems);
    on<LoadCartItems>(_onLoadCartItems);
  }

  Future<void> _onInitialCartItems(
    InitialCartItems event,
    Emitter<CartItemsState> emit,
  ) async {
    emit(CartItemsInitial());
  }

  Future<void> _onLoadCartItems(
    LoadCartItems event,
    Emitter<CartItemsState> emit,
  ) async {
    emit(CartItemsLoaded());
  }
}
