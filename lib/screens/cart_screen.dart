import 'package:ein_ecommerce/blocs/app_connection_bloc/app_connection_bloc.dart';
import 'package:ein_ecommerce/constants/app_colors.dart';
import 'package:ein_ecommerce/screens/connection/error_screen.dart';
import 'package:ein_ecommerce/utils/shimmer_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      body: const CartItems(),
      bottomNavigationBar: const CheckoutSection(),
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
    return RefreshIndicator(
      displacement: 20,
      onRefresh: () async {
        context.read<AppConnectionBloc>().add(CheckAppConnectionEvent());
      },
      color: AppColors.primary,
      backgroundColor: Colors.white,
      child: Scaffold(
        body: BlocBuilder<AppConnectionBloc, AppConnectionState>(
          builder: (context, state) {
            if (state is AppConnectionInitial) {
              return ShimmerHelper(
                child: (context) => _buildCartBody(context),
              );
            } else if (state is NoInternetState) {
              return ErrorScreen(errorType: state.message);
            } else if (state is ServerUnreachableState) {
              return ErrorScreen(errorType: state.message);
            } else if (state is ConnectedState) {
              return _buildCartBody(context);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> dummyCartItems = List.generate(10, (index) {
    return {
      'name': 'Product Name',
      'price': 100000,
      'quantity': 100,
    };
  });

  // This should be replaced with actual cart items
  final List<Map<String, dynamic>> actualCartItems = [
    {
      'name': 'Product 1',
      'price': 50000,
      'quantity': 2,
    },
    {
      'name': 'Product 2',
      'price': 50000,
      'quantity': 1,
    },
    {
      'name': 'Product 3',
      'price': 50000,
      'quantity': 1,
    },
  ];

  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    cartItems = dummyCartItems;
  }

  Widget _buildCartBody(BuildContext context) {
    return BlocConsumer<AppConnectionBloc, AppConnectionState>(
      listener: (context, state) {
        if (state is ConnectedState) {
          cartItems = actualCartItems;
        } else {
          cartItems = dummyCartItems;
        }
      },
      builder: (context, state) {
        return ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final item = cartItems[index];
            return ListTile(
              leading: ShimmerContainer(
                child: RoundCheckBox(
                  animationDuration: const Duration(milliseconds: 100),
                  checkedColor: Colors.grey[900],
                  size: 30,
                  onTap: (value) {},
                ),
              ),
              title: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Rp ${item['price']} x ${item['quantity']}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              trailing: ShimmerContainer(
                child: Text(
                  'Rp ${item['price'] * item['quantity']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CheckoutSection extends StatelessWidget {
  const CheckoutSection({super.key});

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
                child: Text(
                  'Rp 200.000',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
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
