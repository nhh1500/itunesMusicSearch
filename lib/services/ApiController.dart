import 'package:itunes_music/services/ItunesMusicApi.dart';
import 'package:itunes_music/utility/sharedPrefs.dart';

class ApiController {
  static const String scheme = 'https';
  static const String host = 'itunes.apple.com';
  static String apiUrl = Uri(scheme: scheme, host: host, path: '').toString();
  static ItunesMusicApi itunesMusicApi = ItunesMusicApi();
}
