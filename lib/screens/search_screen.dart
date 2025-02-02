import 'package:flutter/material.dart';

class SearchScreenDelegate extends SearchDelegate {
  final String searchLabel;

  SearchScreenDelegate({
    this.searchLabel = 'Search',
  }) : super(
    searchFieldLabel: searchLabel,
  );

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