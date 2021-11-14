import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yts_wrapper/api.dart';
import 'package:yts_wrapper/screens/downstream.dart';

class Details extends StatefulWidget {
  final Movie movie;
  Details({required this.movie});
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  ImageProvider bgImg = AssetImage('lib/src/fallback-cover.jpg');
  @override
  void initState() {
    super.initState();
    ImageProvider img;
    try {
      img = NetworkImage(widget.movie.background_image_original);
    } catch (e) {
      img = bgImg;
    }
    setState(() {
      bgImg = img;
    });
  }

  void _urlLauncher(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Details',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0.8,
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: bgImg,
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
                Center(
                  child: Card(
                    elevation: 15,
                    child: Hero(
                      tag: widget.movie.id,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.movie.large_cover_image),
                          placeholder: AssetImage('lib/src/fallback-cover.jpg'),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.movie.title,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DetailIcon(
                      icon: Icons.timer,
                      data: widget.movie.runtime.toString(),
                    ),
                    DetailIcon(
                      icon: Icons.calendar_today,
                      data: widget.movie.year.toString(),
                    ),
                    DetailIcon(
                      icon: Icons.star,
                      data: widget.movie.rating.toString(),
                    ),
                    DetailIcon(
                      icon: Icons.translate,
                      data: widget.movie.language.toString().toUpperCase(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.movie.summary,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () => _urlLauncher(
                      'https://youtu.be/${widget.movie.yt_trailer_code}'),
                  child: Container(
                      height: 50,
                      child: Column(
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Watch Trailer',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          )
                        ],
                      ))),
              TextButton(
                  onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => DownStream(
                                      movie: widget.movie,
                                      bgimg: bgImg,
                                    )))
                      },
                  child: Container(
                      height: 50,
                      child: Column(
                        children: [
                          Icon(
                            Icons.download,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Downloads',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          )
                        ],
                      ))),
            ],
          ),
        ));
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          primary: Colors.black,
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              icon,
              size: 30,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailIcon extends StatelessWidget {
  const DetailIcon({
    Key? key,
    required this.data,
    required this.icon,
  }) : super(key: key);

  final String data;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              size: 35,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              data,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
