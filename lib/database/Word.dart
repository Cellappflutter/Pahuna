import 'package:ecommerce_app_ui_kit/Model/Data.dart';
import 'package:wordpress_api/wordpress_api.dart';

import '../Model/Data.dart';

class Wordget {
  WordPressAPI api = WordPressAPI('http://cellapp.info/demo/crm/wp-json/wp/v2');

  Future<List<Featuredata>> word() async {
    try {
      final posts = (await api.getAsync('posts'))['data'];
      List<Featuredata> data = List<Featuredata>();
      for (final post in posts) {
        Featuredata data1 = Featuredata(
            title: post['title']['rendered'],
            image: post['jetpack_featured_media_url'],
            content: post['content']['rendered'],
            id: post['id'].toString());
        data.add(data1);
      }
      return data;
   } catch (e) {
      return [];
   }
  }
}
