import 'dart:convert';
import 'package:dio/dio.dart';

class YtsApi {
  late List<String> urls;
  late String requestURL;
  late String useURL;
  YtsApi();

  YtsApi._create() {
    urls = [
      'https://yts.mx',
      'https://yts.pm',
      'https://yts.gs',
      'http://pastvision.pythonanywhere.com',
    ];
    //   'https://yts.vc',
    //   'https://yts.it',
    //   'https://yts.unblockit.top',
    //   'https://yts.unblockit.eu',
    //   'https://yts.unblocked.lc',
    //   'https://yts.ai',
    //   'https://yts.unblockit.onl',
    // ];
  }

  static Future<YtsApi> create() async {
    var instance = YtsApi._create();
    instance.useURL = await instance.pingYTS();
    return instance;
  }

  Future<String> pingYTS() async {
    for (String base_url in urls) {
      try {
        // print('testing: $base_url');
        requestURL = base_url == 'http://pastvision.pythonanywhere.com'
            ? '/api'
            : '/api/v2/list_movies.json';
        var response = await Dio()
            .head(base_url + requestURL)
            .timeout(Duration(seconds: 5));
        if (response.statusCode == 200) {
          return base_url + requestURL;
        }
      } catch (e) {}
    }
    return '';
  }

  Future<List<Movie>> getMovies(
      {required String query_term,
      int limit = 20,
      int page = 1,
      String sortBy = 'date_added',
      String orderBy = 'desc'}) async {
    Map<String, String> parameters = {
      'limit': limit.toString(),
      'query_term': query_term,
      'page': page.toString(),
      'sort_by': sortBy,
      'order_by': orderBy
    };
    List<Movie> movies = [];
    String queryString = Uri(queryParameters: parameters).query;
    String url = useURL + '?' + queryString;
    var response = await Dio().get(url);
    Map<String, dynamic> data = jsonDecode(response.toString());
    // print(data['status']);
    if (data['status'] == 'ok') {
      Iterable mov = data['data']['movies'];
      for (var i in mov) {
        movies.add(Movie.fromJson(i, useURL));
      }
    }
    return movies;
  }
}

class MovQuality {
  final String hash;
  final String torrent;
  final String type;
  final String resolution;
  final String size;
  final String seeds;
  final String peers;
  final String title;
  late String magnetLink;
  final List<String> trackers = [
    'udp://open.demonii.com:1337/announce',
    'udp://tracker.openbittorrent.com:80',
    'udp://tracker.coppersurfer.tk:6969',
    'udp://glotorrents.pw:6969/announce',
    'udp://tracker.opentrackr.org:1337/announce',
    'udp://torrent.gresille.org:80/announce',
    'udp://p4p.arenabg.com:1337',
    'udp://tracker.leechers-paradise.org:6969',
  ];

  MovQuality({
    required this.title,
    required this.hash,
    required this.torrent,
    required this.type,
    required this.resolution,
    required this.size,
    required this.seeds,
    required this.peers,
  }) {
    magnetLink = makeMagnet();
  }

  String makeMagnet() {
    String magnet = 'magnet:?xt=urn:btih:$hash&dn=$title $resolution $type';
    for (String tracker in trackers) {
      magnet += '&tr=$tracker';
    }
    return magnet;
  }

  factory MovQuality.fromJson(
      Map<String, dynamic> json, String title, String useURL) {
    return MovQuality(
        title: title,
        hash: (json['hash']),
        torrent: useURL == 'http://pastvision.pythonanywhere.com'
            ? "http://pastvision.pythonanywhere.com/torrent?hash=${json['hash']}"
            : json['url'],
        type: json['type'],
        resolution: json['quality'],
        size: json['size'],
        seeds: json['seeds'],
        peers: json['peers']);
  }
}

class Movie {
  final int id;
  final String useURL;
  final String title;
  final int year;
  final dynamic rating;
  final int runtime;
  final String summary;
  final String yt_trailer_code;
  final String language;
  final String background_image_original;
  final String large_cover_image;
  final String medium_cover_image;
  final Iterable torrents;
  late List<MovQuality> qualities;

  Movie(
      {required this.id,
      required this.title,
      required this.year,
      required this.rating,
      required this.runtime,
      required this.summary,
      required this.yt_trailer_code,
      required this.language,
      required this.background_image_original,
      required this.large_cover_image,
      required this.medium_cover_image,
      required this.torrents,
      required this.useURL}) {
    qualities = getQualities();
  }

  factory Movie.fromJson(Map<String, dynamic> json, String useURL) {
    return Movie(
        id: json['id'],
        title: json['title_english'],
        year: json['year'],
        rating: json['rating'],
        runtime: json['runtime'],
        summary: json['summary'],
        yt_trailer_code: json['yt_trailer_code'],
        language: json['language'],
        background_image_original: useURL ==
                'http://pastvision.pythonanywhere.com'
            ? "http://pastvision.pythonanywhere.com/image?url=${json['background_image_original']}"
            : json['background_image_original'],
        large_cover_image: useURL == 'http://pastvision.pythonanywhere.com'
            ? "http://pastvision.pythonanywhere.com/image?url=${json['large_cover_image']}"
            : json['large_cover_image'],
        medium_cover_image: useURL == 'http://pastvision.pythonanywhere.com'
            ? "http://pastvision.pythonanywhere.com/image?url=${json['medium_cover_image']}"
            : json['medium_cover_image'],
        torrents: json['torrents'],
        useURL: useURL);
  }

  List<MovQuality> getQualities() {
    List<MovQuality> result = [];
    if (torrents.isNotEmpty) {
      for (var qual in torrents) {
        result.add(MovQuality(
            title: title,
            hash: qual['hash'].toString(),
            torrent: useURL == 'http://pastvision.pythonanywhere.com'
                ? "http://pastvision.pythonanywhere.com/torrent?hash=${qual['hash'].toString()}"
                : qual['url'].toString(),
            type: qual['type'].toString(),
            resolution: qual['quality'].toString(),
            size: qual['size'].toString(),
            seeds: qual['seeds'].toString(),
            peers: qual['peers'].toString()));
      }
    }
    return result;
  }
}

// void main(List<String> args) async {
//   var api = await YtsApi.create();
//   if (api.useURL == '') {
//     throw ("Can't Connect!");
//   } else {
//     print('[DEBUG] Connected to: ${api.useURL}');
//   }
//   List<Movie> movies = await api.getMovies(query_term: 'snyder', limit: 1);
//   for (Movie i in movies) {
//     for (MovQuality qual in i.qualities) {
//       print(qual.magnetLink);
//     }
//   }
// }
