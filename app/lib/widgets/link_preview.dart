import 'package:cookoff/providers/local_link_preview_provider.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkPreviewer extends StatelessWidget {
  final String url;

  LinkPreviewer({@required this.url});

  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: InjectorWidget.of(context).injector.previewProvider.getMetaData(url),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: Scaler(context).scale(150),
            width: MediaQuery
                .of(context)
                .size
                .width,
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            height: Scaler(context).scale(150),
            width: MediaQuery
                .of(context)
                .size
                .width,
          );
        }

        if (snapshot.hasError) {
          return Container(
            height: Scaler(context).scale(150),
            width: MediaQuery
                .of(context)
                .size
                .width,
          );
        }

        var imageUrl = snapshot.data['image_url'];
        var title = snapshot.data['title'];
        var description = snapshot.data['description'];
        var domain = Uri
            .parse(url)
            .host;

        return GestureDetector(
          onTap: _launchURL,
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: Scaler(context).scale(150),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(imageUrl),
                          ),
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(Scaler(context).scale(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: Scaler(context).scale(10)),
                              child: Text(
                                title,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                  fontSize: Scaler(context).scale(17),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              description,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black54,
                                height: 1.2,
                                fontSize: Scaler(context).scale(13),
                              ),
                            ),
                            Container(
                              height: Scaler(context).scale(10),
                            ),
                            Text(
                              domain,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black54,
                                height: 1.2,
                                fontSize: Scaler(context).scale(13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
