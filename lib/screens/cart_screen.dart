import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

class CartItems extends StatelessWidget {
  const CartItems({super.key});

  @override
  Widget build(BuildContext context) {
    // This should be replaced with actual cart items
    final List<Map<String, dynamic>> cartItems = [
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

    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return ListTile(
          leading: Image.asset('assets/images/dashboard/shirt1.webp'),
          title: Text(item['name']),
          subtitle: Text('Rp ${item['price']} x ${item['quantity']}'),
          trailing: Text('Rp ${item['price'] * item['quantity']}'),
        );
      },
    );
  }
}

class CheckoutSection extends StatelessWidget {
  const CheckoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      height: 75,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, -3), // Shadow ke atas
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Text(
                  'Rp 200.000',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
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
      ),
    );
  }
}
