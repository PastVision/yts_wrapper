import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yts_wrapper/api.dart';
import 'package:recase/recase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard/clipboard.dart';

class DownStream extends StatelessWidget {
  final Movie movie;
  final ImageProvider bgimg;
  DownStream({required this.movie, required this.bgimg});

  void _urlLauncher(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: 'No app found to handle torrent');
    }
  }

  List<TableRow> qualBuilder() {
    List<TableRow> quals = [];
    for (MovQuality qual in movie.qualities) {
      quals.add(TableRow(
        children: [
          RowText(
            text: '${qual.type.pascalCase} ${qual.resolution} ${qual.size}',
          ),
          TextButton(
            child: RowText(text: 'Magnet'),
            onPressed: () => _urlLauncher(qual.magnetLink),
            onLongPress: () => FlutterClipboard.copy(qual.magnetLink).then(
                (value) => Fluttertoast.showToast(
                    msg: 'Magnet link copied to clipboard!')),
          ),
          TextButton(
            child: RowText(text: 'Torrent'),
            onPressed: () => _urlLauncher(qual.torrent),
            onLongPress: () => FlutterClipboard.copy(qual.torrent).then(
                (value) => Fluttertoast.showToast(
                    msg: 'Torrent link copied to clipboard!')),
          ),
          TextButton(
            child: RowText(text: 'Stream'),
            onPressed: () => Fluttertoast.showToast(msg: 'Coming Soon!'),
          )
        ],
      ));
    }
    return quals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Downloads',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.8,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: bgimg,
                colorFilter: new ColorFilter.mode(
                    Colors.white.withOpacity(0.55), BlendMode.lighten),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Column(
            children: [
              Text(
                movie.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'Available Qualities',
                        style: TextStyle(
                          fontSize: 17,
                          letterSpacing: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: qualBuilder(),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Tap and hold on Magnet or Torrent to copy respective link to clipboard.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Streaming requires external media player for now (Ex: VLC, MX Player etc.) and 1.5x Free Space.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RowText extends StatelessWidget {
  const RowText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 12),
    );
  }
}
