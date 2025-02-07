import 'package:ein_ecommerce/blocs/app_connection_bloc/app_connection_bloc.dart';
import 'package:ein_ecommerce/components/buttons/primary_button.dart';
import 'package:ein_ecommerce/constants/app_colors.dart';
import 'package:ein_ecommerce/screens/connection/error_screen.dart';
import 'package:ein_ecommerce/screens/search_screen.dart';
import 'package:ein_ecommerce/utils/shimmer_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _username = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final box = Hive.box('appBox');
    _username = box.get('user', defaultValue: const {})['username'] ?? '';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    context.read<AppConnectionBloc>().add(CheckAppConnectionEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                child: (context) => _buildDashboardBody(context),
              );
            } else if (state is ConnectedState) {
              return _buildDashboardBody(context);
            } else {
              return ErrorScreen(errorType: state.message);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDashboardBody(BuildContext context) {
    return BlocBuilder<AppConnectionBloc, AppConnectionState>(
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/profile');
                            },
                            child: const ClipOval(
                              child: Image(
                                image: ResizeImage(
                                  AssetImage('assets/images/sample/profile1.webp'),
                                  width: 100, // Atur lebar gambar yang di-resize
                                  height: 100, // Atur tinggi gambar yang di-resize
                                ),
                                fit: BoxFit.cover,
                                width: 50, // Atur lebar gambar
                                height: 50, // Atur tinggi gambar
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              state != ConnectedState()
                                  ? const ShimmerContainer(
                                      height: 20.0,
                                      width: 140.0,
                                      margin: EdgeInsets.only(bottom: 5),
                                      borderRadius: 6.0,
                                      child: SizedBox(),
                                    )
                                  : Text(
                                      'Hi $_username!',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w300,
                                        color: AppColors.primary,
                                      ),
                                    ),
                              ShimmerContainer(
                                child: Text(
                                  'Dashboard',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showSearch(
                          context: context,
                          delegate: SearchScreenDelegate(),
                        );
                      },
                      child: ShimmerContainer(
                        child: Icon(
                          Icons.search,
                          size: 30,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.black, Colors.grey[700] ?? Colors.grey],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Flash Sale'.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Discount up to 50%',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.orange[400],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'All Products',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            PrimaryButton(
                              text: 'Check Now',
                              backgroundColor: Colors.orange[400],
                              onPressed: () {
                                Navigator.pushNamed(context, '/flash-sale');
                              },
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: -50,
                        right: -50,
                        child: Image.asset(
                          'assets/images/dashboard/discount1.webp',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const ShimmerContainer(
                          child: Text(
                            'Trending',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        PrimaryButton(
                          text: 'See All',
                          onPressed: () {
                            Navigator.pushNamed(context, '/trending');
                          },
                          backgroundColor: Colors.grey[600],
                          textSize: 14,
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        height: 335,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 200,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        width: double.infinity,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.grey[200],
                                        ),
                                        child: ClipRect(
                                          child: Align(
                                            alignment: Alignment.center, // Potong di tengah
                                            widthFactor: 1, // Faktor pemotongan lebar (100%)
                                            heightFactor: 1, // Faktor pemotongan tinggi (250/300)
                                            child: Image.asset(
                                              'assets/images/dashboard/shirt1.webp',
                                              height: 150,
                                              fit: BoxFit.cover, // Sesuaikan gambar dengan area yang tersedia
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Product Name',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis, // Tambahkan ini
                                                maxLines: 2,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Rp 1.000.000',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                      bottom: 10,
                                      left: 13,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 17,
                                                color: Colors.orange[400],
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                '4.5',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '100x Sold',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ],
                                      )),
                                  Positioned(
                                    bottom: 5,
                                    right: 8,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty.all(Colors.green[400]),
                                        foregroundColor: WidgetStateProperty.all(Colors.white),
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
                                      ),
                                      child: const Icon(Icons.add_shopping_cart),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: ['Blouse', 'Uniform', 'Shirt', 'Jacket', 'Pants', 'Dress', 'Hoodie', 'T-Shirt', 'More'].map((category) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(category),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
