import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:yts_wrapper/api.dart';
import 'package:yts_wrapper/listbuilders.dart';
import 'package:yts_wrapper/screens/results.dart';

class HomePage extends StatefulWidget {
  YtsApi api;
  HomePage(this.api);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SearchBar searchBar;
  List<Movie> newAdded = [];
  List<Movie> topRated = [];
  final int previewCount = 10;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Text(
        'YTS',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      elevation: 0.8,
      actions: [searchBar.getSearchAction(context)],
    );
  }

  _HomePageState() {
    searchBar = new SearchBar(
        inBar: true,
        setState: setState,
        onSubmitted: (query) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Results(query: query, api: widget.api)));
        },
        buildDefaultAppBar: buildAppBar);
  }

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies({String query_term = '0'}) async {
    List<Movie> latest =
        await widget.api.getMovies(query_term: query_term, limit: previewCount);
    List<Movie> top = await widget.api.getMovies(
        query_term: query_term, limit: previewCount, sortBy: 'rating');
    setState(() {
      newAdded = latest;
      topRated = top;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: searchBar.build(context),
      body: RefreshIndicator(
        onRefresh: () => fetchMovies(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Newly Added',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      child: Text('View All'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Results(
                                    title: 'Newly Added',
                                    query: '0',
                                    api: widget.api)));
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: newAdded.length,
                  itemBuilder: (context, i) => NewAddedBuilder(newAdded[i]),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Top Rated',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      child: Text('View All'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Results(
                                    title: 'Top Rated',
                                    query: '0',
                                    api: widget.api)));
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topRated.length,
                  itemBuilder: (context, i) => NewAddedBuilder(topRated[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
