import 'package:ein_ecommerce/blocs/app_connection_bloc/app_connection_bloc.dart';
import 'package:ein_ecommerce/screens/connection/error_screen.dart';
import 'package:ein_ecommerce/utils/refresh_helper.dart';
import 'package:ein_ecommerce/utils/shimmer_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class Chat {
  final String name;
  final String message;
  final String time;

  Chat({required this.name, required this.message, required this.time});
}

class _ChatPageState extends State<ChatPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  List<Chat> _chats = [];
  List<Chat> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _loadChats() async {
    _chats = [
      Chat(name: 'John Doe', message: 'Hai, gimana kabar?', time: '10:00'),
      Chat(name: 'Jane Doe', message: 'Baik, terima kasih', time: '11:00'),
      Chat(name: 'Bob Smith', message: 'Saya ingin tahu lebih banyak tentang produk ini', time: '12:00'),
      Chat(name: 'Alice Johnson', message: 'Saya ingin memesan produk ini', time: '13:00'),
      Chat(name: 'Michael Brown', message: 'Saya ingin tahu lebih banyak tentang promo ini oapakahhhhhhhhhhhhhhhhhhhh', time: '14:00'),
      Chat(name: 'Chris Evans', message: 'Apa ada diskon?', time: '15:00'),
      Chat(name: 'Emma Watson', message: 'Bagaimana cara pembeliannya?', time: '16:00'),
      Chat(name: 'Will Smith', message: 'Apakah produk ini tersedia?', time: '17:00'),
      Chat(name: 'Scarlett Johansson', message: 'Berapa lama pengiriman?', time: '18:00'),
      Chat(name: 'Robert Downey Jr.', message: 'Apa metode pembayaran?', time: '19:00'),
    ];
    setState(() {
      _filteredChats = _chats;
    });
  }

  void _searchChats(String query) {
    final filteredChats = _chats.where((chat) {
      return chat.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredChats = filteredChats;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: RefreshHelper(
        onRefresh: () async {
          context.read<AppConnectionBloc>().add(CheckAppConnectionEvent());
        },
        child: BlocBuilder<AppConnectionBloc, AppConnectionState>(
          builder: (context, state) {
            if (state is ConnectedState || state is AppConnectionInitial) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 15.0, bottom: 15.0, top: 10),
                              child: Text(
                                'Chat',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverAppBar(
                      pinned: true,
                      floating: true,
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: state is ConnectedState
                            ? Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3), // Shadow ke bawah
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: 'Search',
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  onSubmitted: (query) {
                                    _searchChats(query);
                                  },
                                  onTapOutside: (event) {
                                    _searchChats(_searchController.text);
                                  },
                                ),
                              )
                            : Shimmer.fromColors(
                                baseColor: ShimmerHelper.defaultBaseColor,
                                highlightColor: ShimmerHelper.defaultHighlightColor,
                                child: ShimmerContainer(
                                  width: MediaQuery.of(context).size.width,
                                  child: null,
                                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                ),
                              ),
                      ),
                      expandedHeight: 60.0,
                      collapsedHeight: 60.0,
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return BlocBuilder<AppConnectionBloc, AppConnectionState>(
                            builder: (context, state) {
                              if (state is ConnectedState) {
                                return _buildChatItem(index: index, isShimmer: false);
                              } else {
                                return ShimmerHelper(
                                  child: (context) => _buildChatItem(index: index, isShimmer: true),
                                );
                              }
                            },
                          );
                        },
                        childCount: _filteredChats.length,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ErrorScreen(errorType: state.message);
            }
          },
        ),
      ),
    );
  }

  Widget _buildChatItem({required int index, bool isShimmer = false}) {
    if (isShimmer) {
      return const ListTile(
        leading: ShimmerContainer(
          width: 50,
          height: 50,
          child: null,
        ),
        title: ShimmerContainer(
          width: 150,
          height: 50,
          child: null,
        ),
        trailing: ShimmerContainer(
          width: 50,
          height: 50,
          child: null,
        ),
      );
    } else {
      return ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.orange[600],
          child: ClipOval(
            child: Image.asset(
              'assets/images/dashboard/shirt1.webp',
              fit: BoxFit.cover, // Atur scaling gambar
              width: 50, // Atur lebar gambar
              height: 50, // Atur tinggi gambar
            ),
          ),
        ),
        title: ShimmerContainer(
          child: Text(
            _filteredChats[index].name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: ShimmerContainer(
          child: Text(
            _filteredChats[index].message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: ShimmerContainer(
          child: Text(_filteredChats[index].time),
        ),
      );
    }
  }
}
