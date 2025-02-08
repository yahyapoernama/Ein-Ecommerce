import 'package:ein_ecommerce/blocs/app_connection_bloc/app_connection_bloc.dart';
import 'package:ein_ecommerce/blocs/cart_bloc/cart_bloc.dart';
import 'package:ein_ecommerce/screens/connection/error_screen.dart';
import 'package:ein_ecommerce/utils/refresh_helper.dart';
import 'package:ein_ecommerce/utils/shimmer_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<AppConnectionBloc>().add(CheckAppConnectionEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: const SafeArea(
        child: CartItems(),
      ),
      bottomNavigationBar: BlocBuilder<AppConnectionBloc, AppConnectionState>(
        builder: (context, state) {
          if (state is ConnectedState || state is AppConnectionInitial) {
            return const CheckoutSection();
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class CartItems extends StatefulWidget {
  const CartItems({super.key});

  @override
  State<CartItems> createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  @override
  Widget build(BuildContext context) {
    return RefreshHelper(
      onRefresh: () async {
        context.read<AppConnectionBloc>().add(CheckAppConnectionEvent());
      },
      child: BlocBuilder<AppConnectionBloc, AppConnectionState>(
        builder: (context, state) {
          if (state is AppConnectionInitial) {
            return ShimmerHelper(
              child: (context) => _buildCartBody(context),
            );
          } else if (state is ConnectedState) {
            return _buildCartBody(context);
          } else {
            return ErrorScreen(errorType: state.message);
          }
        },
      ),
    );
  }

  Widget _buildCartBody(BuildContext context) {
    return BlocConsumer<AppConnectionBloc, AppConnectionState>(
      listener: (context, state) {
        if (state is ConnectedState) {
          context.read<CartItemsBloc>().add(const LoadCartItems([]));
        } else {
          context.read<CartItemsBloc>().add(const InitialCartItems([]));
        }
      },
      builder: (context, state) {
        return BlocBuilder<CartItemsBloc, CartItemsState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.cartItems.length,
              itemBuilder: (context, index) {
                final item = state.cartItems[index];
                return ListTile(
                  leading: ShimmerContainer(
                    child: RoundCheckBox(
                      animationDuration: const Duration(milliseconds: 100),
                      checkedColor: Colors.grey[900],
                      size: 30,
                      isChecked: item['isChecked'],
                      onTap: (isChecked) {
                        setState(() {
                          item['isChecked'] = isChecked;
                        });
                        if (isChecked as bool) {
                          context.read<TotalPriceBloc>().add(UpdateTotalPrice((item['price'] * item['quantity']).toDouble()));
                        } else {
                          context.read<TotalPriceBloc>().add(UpdateTotalPrice(-(item['price'] * item['quantity']).toDouble()));
                        }
                      },
                    ),
                  ),
                  title: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black),
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/dashboard/shirt1.webp',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ShimmerContainer(
                        width: MediaQuery.of(context).size.width * 0.47,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Rp ${item['price']} x ${item['quantity']}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: ShimmerContainer(
                    width: 50,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          state.cartItems.removeAt(index);
                        });
                        if (item['isChecked'] == true) {
                          context.read<TotalPriceBloc>().add(
                                UpdateTotalPrice(
                                  -(item['price'] * item['quantity']).toDouble(),
                                ),
                              );
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class CheckoutSection extends StatefulWidget {
  const CheckoutSection({super.key});

  @override
  State<CheckoutSection> createState() => _CheckoutSectionState();
}

class _CheckoutSectionState extends State<CheckoutSection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Column(
        children: [
          BlocBuilder<AppConnectionBloc, AppConnectionState>(builder: (context, state) {
            if (state is ConnectedState) {
              return _enterCouponSection();
            } else {
              return ShimmerHelper(
                child: (context) => _enterCouponSection(),
              );
            }
          }),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, -3), // Shadow ke atas
                  ),
                ],
              ),
              child: BlocBuilder<AppConnectionBloc, AppConnectionState>(
                builder: (context, state) {
                  if (state is ConnectedState) {
                    return _checkoutSection();
                  } else {
                    return ShimmerHelper(
                      child: (context) => _checkoutSection(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _enterCouponSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      decoration: const BoxDecoration(
        color: Colors.orange,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, -3), // Shadow ke atas
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(
            Icons.local_offer,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Text(
            'Masukkan Kupon',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _checkoutSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShimmerContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[900],
                ),
              ),
              Expanded(
                child: BlocBuilder<TotalPriceBloc, TotalPriceState>(
                  builder: (context, state) {
                    final connectState = context.read<AppConnectionBloc>().state;
                    return Text(
                      connectState != ConnectedState()
                          ? 'Rp XXXXXXXXXX'
                          : NumberFormat.currency(
                              locale: 'id',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            ).format(state.totalPrice),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.green),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
          ),
          child: const Row(
            children: [
              Icon(Icons.upload),
              SizedBox(width: 5),
              Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
