import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/transaction_bloc/transaction_bloc.dart';

// import '../../blocs/transaction_bloc/transaction_bloc.dart';
// import '../../widgets/transaction_badge.dart';
// import '../../widgets/transaction_list.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Transaction',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TransactionSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoaded) {
            return const Column(
              children: [
                Text('Transactions'),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     children: [
                //       TransactionBadge(
                //         status: 'all',
                //         onPressed: () {
                //           BlocProvider.of<TransactionBloc>(context)
                //               .add(TransactionStatusChanged('all'));
                //         },
                //       ),
                //       TransactionBadge(
                //         status: 'pending',
                //         onPressed: () {
                //           BlocProvider.of<TransactionBloc>(context)
                //               .add(TransactionStatusChanged('pending'));
                //         },
                //       ),
                //       TransactionBadge(
                //         status: 'success',
                //         onPressed: () {
                //           BlocProvider.of<TransactionBloc>(context)
                //               .add(TransactionStatusChanged('success'));
                //         },
                //       ),
                //       TransactionBadge(
                //         status: 'failed',
                //         onPressed: () {
                //           BlocProvider.of<TransactionBloc>(context)
                //               .add(TransactionStatusChanged('failed'));
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                // Expanded(
                //   child: TransactionList(
                //     transactions: state.transactions,
                //   ),
                // ),
              ],
            );
          } else {
            return const Center(
              child: Text('Loading'),
            );
          }
        },
      ),
    );
  }
}

class TransactionSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(
      child: Text('Search Results'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Search Suggestions'),
    );
  }
}
