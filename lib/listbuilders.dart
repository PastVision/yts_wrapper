import 'package:flutter/material.dart';
import 'package:yts_wrapper/api.dart';
import 'package:yts_wrapper/screens/details.dart';

class NewAddedBuilder extends StatelessWidget {
  final Movie mov;
  NewAddedBuilder(this.mov);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Details(movie: mov)));
        },
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Hero(
                tag: mov.id,
                child: Container(
                  height: 200,
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(mov.medium_cover_image),
                    imageErrorBuilder: (context, object, stacktrace) {
                      return Container(
                        child: Image(
                            image: AssetImage('lib/src/fallback-cover.jpg')),
                      );
                    },
                    placeholder: AssetImage('lib/src/fallback-cover.jpg'),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 150,
              child: Text(
                mov.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchItemBuilder extends StatelessWidget {
  final Movie mov;
  SearchItemBuilder(this.mov);

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Details(movie: mov)));
        },
        child: Card(
          elevation: 5,
          child: Row(
            children: [
              Hero(
                tag: mov.id,
                child: Container(
                  height: 145,
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(mov.medium_cover_image),
                    imageErrorBuilder: (context, object, stacktrace) {
                      return Container(
                        child: Image(
                            image: AssetImage('lib/src/fallback-cover.jpg')),
                      );
                    },
                    placeholder: AssetImage('lib/src/fallback-cover.jpg'),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                height: 145,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text(
                        mov.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: 95,
                      child: Text(
                        mov.summary,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
