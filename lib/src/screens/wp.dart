import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/src/screens/detailspage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class WordPress extends StatelessWidget {
  wp.WordPress wordPress = wp.WordPress(
    // baseUrl: 'https://demo.wp-api.org/wp-json/wp/v2/posts',
    // baseUrl: 'https://demo.wp-api.org',
    // baseUrl: 'http://cellapp.info/demo/crm/wp-json/wp/v2/posts',
    baseUrl: 'http://cellapp.info/demo/crm',
  );

  _fetchPosts() {
    Future<List<wp.Post>> posts = wordPress.fetchPosts(
        postParams: wp.ParamsPostList(
          context: wp.WordPressContext.view,
          pageNum: 1,
          perPage: 10,
        ),
        fetchAuthor: true,
        fetchFeaturedMedia: true,
        fetchComments: true);
    return posts;
  }

  _getPostsImage(wp.Post post) {
    if (post.featuredMedia == null) {
      return SizedBox();
    }
    return
    CachedNetworkImage(
      imageUrl: post.featuredMedia.sourceUrl,
      placeholder: (context,url) => CircularProgressIndicator(),
      errorWidget: (context,url,error) => Icon(Icons.error),
    );
    // Image(image: CachedNetworkImageProvider(post.featuredMedia.sourceUrl),); 
    // Image.network(post.featuredMedia.sourceUrl);
  }

  _launchUrl(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Cannot launch $link';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('WordPress Demo API'),
          centerTitle: true,
        ),
        body: Container(
          child: FutureBuilder(
            future: _fetchPosts(),
            builder:
                (BuildContext context, AsyncSnapshot<List<wp.Post>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    wp.Post post = snapshot.data[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsPage(post)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  // _getPostsImage(post),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    post.title.rendered.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  // Html(
                                  //   data:post.excerpt.rendered.toString(),
                                  //   onLinkTap:(String link){
                                  //     _launchUrl(link);
                                  //   },
                                  // ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(post.date
                                          .toString()
                                          .replaceAll('T', '')),
                                      Text(post.author.name),
                                    ],
                                  )
                                ],
                              )),
                        ),
                      ),
                    );
                  });
            },
          ),
        ));
  }
}
