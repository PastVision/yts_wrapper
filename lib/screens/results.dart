import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:yts_wrapper/api.dart';
import 'package:yts_wrapper/listbuilders.dart';

class Results extends StatefulWidget {
  final String query;
  final String title;
  final YtsApi api;
  Results({required this.query, required this.api, this.title = 'Search'});
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  static const _pageSize = 20;
  String sortBy = 'date_added';
  String orderBy = 'desc';

  final PagingController<int, Movie> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  void sort({String sort = '', String order = ''}) {
    if (sort == '') {
      sort = sortBy;
    }
    if (order == '') {
      order = orderBy;
    }
    setState(() {
      sortBy = sort;
      orderBy = order;
    });
    _pagingController.refresh();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (widget.title == 'Top Rated') {
        sortBy = 'rating';
      }
      final newItems = await widget.api.getMovies(
          query_term: widget.query,
          limit: _pageSize,
          page: pageKey,
          sortBy: sortBy,
          orderBy: orderBy);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        _pagingController.appendPage(newItems, pageKey + 1);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.8,
        actions: [
          PopupMenuButton(
            tooltip: 'Sort movies by',
            icon: Icon(Icons.sort),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text(
                    'SortBy:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  enabled: false,
                  height: 10,
                ),
                PopupMenuItem(
                  child: Divider(),
                  height: 5,
                ),
                PopupMenuItem(
                  value: 'title',
                  child: Text('Title'),
                  enabled: sortBy != 'title',
                  height: 35,
                ),
                PopupMenuItem(
                  value: 'year',
                  child: Text('Year'),
                  enabled: sortBy != 'year',
                  height: 35,
                ),
                PopupMenuItem(
                  value: 'rating',
                  child: Text('Rating'),
                  enabled: sortBy != 'rating',
                  height: 35,
                ),
                PopupMenuItem(
                  value: 'date_added',
                  child: Text('Date Added'),
                  enabled: sortBy != 'date_added',
                  height: 35,
                ),
                PopupMenuItem(
                  child: Divider(),
                  height: 5,
                ),
                PopupMenuItem(
                  child: Text(
                    'OrderBy:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  enabled: false,
                  height: 10,
                ),
                PopupMenuItem(
                  child: Divider(),
                  height: 5,
                ),
                PopupMenuItem(
                  value: 'asc',
                  child: Text('Ascending'),
                  enabled: orderBy != 'asc',
                  height: 35,
                ),
                PopupMenuItem(
                  value: 'desc',
                  child: Text('Descending'),
                  enabled: orderBy != 'desc',
                  height: 35,
                ),
              ];
            },
            onSelected: (value) {
              if (value == 'title') {
                sort(sort: value.toString(), order: 'asc');
              } else if (value == 'asc' || value == 'desc') {
                sort(order: value.toString());
              } else {
                sort(sort: value.toString());
              }
            },
          )
        ],
      ),
      body: PagedListView<int, Movie>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Movie>(
          itemBuilder: (context, item, index) => SearchItemBuilder(item),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
