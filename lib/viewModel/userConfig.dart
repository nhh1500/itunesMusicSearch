import 'package:get/get.dart';

import '../utility/sharedPrefs.dart';

class UserConfig extends GetxController {
  final _initKey = 'init';
  final _searchLangKey = 'searchLang';
  final _searchCountryKey = 'searchCountry';
  final _autoPlayKey = 'AutoPlay';
  final _resumePlayBackKey = 'ResumePlayBack';
  final _equalizerKey = 'Equalizer';
  final _loudnessEnhancerKey = 'LoudnessEnhancer';
  final _recordSearchHistoryKey = 'RecordSearchHistory';
  final _languageKey = 'Language';

  bool _init = false;
  String _searchLang = 'en_us';
  String _searchCountry = 'US';
  bool _autoPlay = true;
  bool _resumePlayBack = false;
  bool _equalizer = true;
  bool _loudnessEnhancer = true;
  bool _recordSearchHistory = true;
  String _language = 'en_US';

  bool get init => _init;
  String get searchLang => _searchLang;
  String get searchCountry => _searchCountry;
  bool get autoPlay => _autoPlay;
  bool get resumePlayBack => _resumePlayBack;
  bool get equalizer => _equalizer;
  bool get loudnessEnhancer => _loudnessEnhancer;
  bool get recordSearchHistory => _recordSearchHistory;
  String get language => _language;

  ///init userConfig if first launch app
  void initApp() {
    if (SharedPrefs.prefs.containsKey('init')) {
      return;
    }
    _init = true;
    setInit(_init);
    setAutoPlay(_autoPlay);
    setResumePlayBack(_resumePlayBack);
    setEqualizer(_equalizer);
    setLoudnessEnhancer(_loudnessEnhancer);
    setRecordSearchHistory(_recordSearchHistory);
  }

  ///set value for init
  void setInit(bool value) {
    _init = value;
    SharedPrefs.setValue(_initKey, _init);
    update();
  }

  void setSearchOnLang(String value) {
    _searchLang = value;
    SharedPrefs.setValue(_searchLangKey, _searchLang);
    update();
  }

  void setSearchOnCountry(String value) {
    _searchCountry = value;
    SharedPrefs.setValue(_searchCountryKey, _searchCountry);
    update();
  }

  ///set value for auto play
  void setAutoPlay(bool value) {
    _autoPlay = value;
    SharedPrefs.setValue(_autoPlayKey, _autoPlay);
    update();
  }

  ///set value for resume play back
  void setResumePlayBack(bool value) {
    _resumePlayBack = value;
    SharedPrefs.setValue(_resumePlayBackKey, _resumePlayBack);
    update();
  }

  ///set value for equalizer
  void setEqualizer(bool value) {
    _equalizer = value;
    SharedPrefs.setValue(_equalizerKey, _equalizer);
    update();
  }

  ///set Value for LoudnessEnhancer
  void setLoudnessEnhancer(bool value) {
    _loudnessEnhancer = value;
    SharedPrefs.setValue(_loudnessEnhancerKey, _loudnessEnhancer);
    update();
  }

  ///set Value for Record search History
  void setRecordSearchHistory(bool value) {
    _recordSearchHistory = value;
    SharedPrefs.setValue(_recordSearchHistoryKey, _recordSearchHistory);
    update();
  }

  ///set value for Language
  void setLanguage(String value) {
    _language = value;
    SharedPrefs.setValue(_languageKey, _language);
    update();
  }

  /// extract userConfig from SharedPreference
  void getConfig() {
    _init = (SharedPrefs.getValue(_initKey, bool) as bool?) ?? _init;
    _searchLang = (SharedPrefs.getValue(_searchLangKey, String) as String?) ??
        _searchLang;
    _searchCountry =
        (SharedPrefs.getValue(_searchCountryKey, String) as String?) ??
            _searchCountry;
    _autoPlay =
        (SharedPrefs.getValue(_autoPlayKey, bool) as bool?) ?? _autoPlay;
    _resumePlayBack =
        (SharedPrefs.getValue(_resumePlayBackKey, bool) as bool?) ??
            _resumePlayBack;
    _equalizer =
        (SharedPrefs.getValue(_equalizerKey, bool) as bool?) ?? equalizer;
    _loudnessEnhancer =
        (SharedPrefs.getValue(_loudnessEnhancerKey, bool) as bool?) ??
            loudnessEnhancer;
    _recordSearchHistory =
        (SharedPrefs.getValue(_recordSearchHistoryKey, bool) as bool?) ??
            _recordSearchHistory;
    _language =
        (SharedPrefs.getValue(_languageKey, String) as String?) ?? _language;
  }
}
