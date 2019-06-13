import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../scalar.dart';

class LinkPreviewer extends StatelessWidget {
  final String url;

  final MethodChannel channel =
      MethodChannel('plugins.flutter.io/link_preview');

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
      future: channel.invokeMethod('metaData', {'url': url}),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: Scaler(context).scale(150),
            width: MediaQuery.of(context).size.width,
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            height: Scaler(context).scale(150),
            width: MediaQuery.of(context).size.width,
          );
        }

        if (snapshot.hasError) {
          return Container(
            height: Scaler(context).scale(150),
            width: MediaQuery.of(context).size.width,
          );
        }

        final imageUrl = snapshot.data['image_url'];
        final title = snapshot.data['title'];
        final description = snapshot.data['description'];

        return GestureDetector(
          onTap: _launchURL,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: Scaler(context).scale(150),
                  width: Scaler(context).scale(150),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.only(bottom: Scaler(context).scale(10)),
                        child: Text(
                          title,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Scaler(context).scale(20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: Scaler(context).scale(12.0),
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
