import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatelessWidget {
  wp.Post post;

  DetailsPage(this.post);

  _getPostImage() {
    if (post.featuredMedia == null) {
      return SizedBox(
        height: 10,
      );
    } else {
      return 
      CachedNetworkImage(
      imageUrl: post.featuredMedia.sourceUrl,
      placeholder: (context,url) => CircularProgressIndicator(),
      errorWidget: (context,url,error) => Icon(Icons.error),
    );
      // Image.network(post.featuredMedia.sourceUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 260,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _getPostImage(),
              // collapseMode: CollapseMode.parallax,
            ),
          ),
        ],
      ),
    );
    // appBar: AppBar(
    //   backgroundColor: Colors.white,
    //   iconTheme: IconThemeData(color: Colors.blue),
    // ),
    // body: Container(
    //   child: Padding(
    //     padding: EdgeInsets.all(10.0),
    //     child: ListView(
    //       children: <Widget>[
    //         Text(
    //           post.title.rendered.toString(),
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //             fontSize: 20
    //           ),
    //         ),
    //         _getPostImage(),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             Text(post.date.replaceAll('T', ' ')),
    //             Text(post.author.name.toString())
    //           ],
    //         ),
    //         Html(
    //           data: post.content.rendered,
    //           onLinkTap: (String url) {
    //             _launchUrl(url);
    //           },
    //         )
    //       ],
    //     ),
    //   )
    // ),
  }
}

_launchUrl(String link) async {
  if (await canLaunch(link)) {
    await launch(link);
  } else {
    throw 'Cannot launch $link';
  }
}
