import 'package:itunes_music/services/Api/apihandler.dart';

/// controller to fetch data from Itunes
class ItunesMusicApi {
  static const String base = 'itunes.apple.com';

  /// To search for content from a field.
  ///
  /// `term` The URL-encoded text string you want to search for. For example: jack+johnson.
  ///
  /// `country` The two-letter country code for the store you want to search. The search uses the default store front for the specified country. For example: US. The default is US.
  ///
  /// `media` The media type you want to search for. For example: movie. The default is all.
  ///
  /// `entity` The type of results you want returned, relative to the specified media type.
  ///
  /// `attribute` The attribute you want to search for in the stores, relative to the specified media type.
  ///
  /// `callback` The name of the Javascript callback function you want to use when returning search results to your website.
  ///
  /// `limit` The number of search results you want the iTunes Store to return. For example: 25. The default is 50.
  ///
  /// `lang` The language, English or Japanese, you want to use when returning search results. Specify the language using the five-letter codename. For example: en_us. The default is en_us (English).
  ///
  /// `version` The search result key version you want to receive back from your search. The default is 2.
  ///
  /// `explicit` 	A flag indicating whether or not you want to include explicit content in your search results. The default is Yes.
  Future<dynamic> search(String term,
      {String? country,
      String? media,
      String? entity,
      String? attribute,
      String? callback,
      int? limit = 200,
      String? lang,
      int? version,
      bool? explicit}) async {
    String endpoint = 'search';
    final queryParameter = {'term': term};
    if (entity != null) {
      queryParameter.addAll({'entity': entity});
    }
    if (attribute != null) {
      queryParameter.addAll({'attribute': attribute});
    }
    if (lang != null) {
      queryParameter.addAll({'lang': lang});
    }
    if (limit != null) {
      queryParameter.addAll({'limit': limit.toString()});
    }
    String url = Uri.https(base, endpoint, queryParameter).toString();
    String encodeUrl = Uri.encodeFull(url);
    print('api send $encodeUrl');
    var response = await ApiHandler.getAPI(encodeUrl);
    print('api return');
    return response;
  }

  /// To search specific Item using unique ID
  ///
  /// `entity` The type of results you want returned, relative to the specified media type.
  ///
  /// `attribute` The attribute you want to search for in the stores, relative to the specified media type.
  ///
  /// `limit` The number of search results you want the iTunes Store to return. For example: 25. The default is 50.
  ///
  /// `lang` The language, English or Japanese, you want to use when returning search results. Specify the language using the five-letter codename. For example: en_us. The default is en_us (English).
  Future<dynamic> lookup(int id,
      {String? entity,
      String? attribute,
      String? lang,
      String? country,
      int? limit = 200}) async {
    String endpoint = 'lookup';
    final Map<String, String> queryParameter = {'id': id.toString()};
    if (entity != null) {
      queryParameter.addAll({'entity': entity});
    }
    if (attribute != null) {
      queryParameter.addAll({'attribute': attribute});
    }
    if (lang != null) {
      queryParameter.addAll({'lang': lang});
    }
    if (country != null) {
      queryParameter.addAll({'country': country});
    }
    if (limit != null) {
      queryParameter.addAll({'limit': limit.toString()});
    }
    String url = Uri.https(base, endpoint, queryParameter).toString();
    String encodeUrl = Uri.encodeFull(url);
    print('api send $encodeUrl');
    var response = await ApiHandler.getAPI(encodeUrl);
    print('api return');

    return response;
  }

  ///lookup multiple music
  Future<dynamic> lookupMutliple(List<int> idList,
      {String? entity,
      String? attribute,
      String? lang,
      String? country,
      int? limit = 200}) async {
    String endpoint = 'lookup';
    final Map<String, dynamic> queryParameter = {'id': idList.join(',')};
    if (entity != null) {
      queryParameter.addAll({'entity': entity});
    }
    if (attribute != null) {
      queryParameter.addAll({'attribute': attribute});
    }
    if (lang != null) {
      queryParameter.addAll({'lang': lang});
    }
    if (country != null) {
      queryParameter.addAll({'country': country});
    }
    if (limit != null) {
      queryParameter.addAll({'limit': limit.toString()});
    }
    String url = Uri.https(base, endpoint, queryParameter)
        .toString()
        .replaceAll(RegExp(r'%2C'), ',');

    String encodeUrl = Uri.encodeFull(url);
    print('api send $encodeUrl');
    var response = await ApiHandler.getAPI(encodeUrl);
    print('api return');

    return response;
  }

  ///extract artist image URL from HTML page
  Future getArtistImageUrl(int artistID) async {
    String imageUrl = '';
    String url = 'https://music.apple.com/de/artist/${artistID.toString()}';
    print('api send $url');
    try {
      var response = await ApiHandler.getAPI(url);
      print('api return');

      RegExp regEx = RegExp("<meta property=\"og:image\" content=\"(.*png)\"");
      RegExpMatch? match = regEx.firstMatch(response);
      if (match != null) {
        String rawImageUrl = match.group(1) ?? '';
        //convert size 100x100 image to 300x300
        imageUrl = rawImageUrl.replaceAll(
            RegExp(r'[\d]+x[\d]+(cw)+'), '${300}x${300}cc');
      }
    } catch (e) {
      print('error : $e');
    }
    return imageUrl;
  }
}
