import 'package:flutter/material.dart';
import 'flutter_flow/request_manager.dart';
import 'backend/supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _isDarkMode = prefs.getBool('ff_isDarkMode') ?? _isDarkMode;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;
  set isDarkMode(bool value) {
    _isDarkMode = value;
    prefs.setBool('ff_isDarkMode', value);
  }

  String _streamResponse = '';
  String get streamResponse => _streamResponse;
  set streamResponse(String value) {
    _streamResponse = value;
  }

  List<String> _foregroundImages = [
    'https://etrgasxxhvyskoekhalf.supabase.co/storage/v1/object/public/Force//Frame_2.png',
    'https://etrgasxxhvyskoekhalf.supabase.co/storage/v1/object/public/Force//Frame_2.png',
    'https://etrgasxxhvyskoekhalf.supabase.co/storage/v1/object/public/Force//Frame_2.png'
  ];
  List<String> get foregroundImages => _foregroundImages;
  set foregroundImages(List<String> value) {
    _foregroundImages = value;
  }

  void addToForegroundImages(String value) {
    foregroundImages.add(value);
  }

  void removeFromForegroundImages(String value) {
    foregroundImages.remove(value);
  }

  void removeAtIndexFromForegroundImages(int index) {
    foregroundImages.removeAt(index);
  }

  void updateForegroundImagesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    foregroundImages[index] = updateFn(_foregroundImages[index]);
  }

  void insertAtIndexInForegroundImages(int index, String value) {
    foregroundImages.insert(index, value);
  }

  List<String> _backgroundImages = [
    'https://etrgasxxhvyskoekhalf.supabase.co/storage/v1/object/public/Force//178620791.jpg',
    'https://etrgasxxhvyskoekhalf.supabase.co/storage/v1/object/public/Force//178620791.jpg',
    'https://etrgasxxhvyskoekhalf.supabase.co/storage/v1/object/public/Force//178620791.jpg'
  ];
  List<String> get backgroundImages => _backgroundImages;
  set backgroundImages(List<String> value) {
    _backgroundImages = value;
  }

  void addToBackgroundImages(String value) {
    backgroundImages.add(value);
  }

  void removeFromBackgroundImages(String value) {
    backgroundImages.remove(value);
  }

  void removeAtIndexFromBackgroundImages(int index) {
    backgroundImages.removeAt(index);
  }

  void updateBackgroundImagesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    backgroundImages[index] = updateFn(_backgroundImages[index]);
  }

  void insertAtIndexInBackgroundImages(int index, String value) {
    backgroundImages.insert(index, value);
  }

  List<String> _texts = ['Ghana', 'South Africa', 'Ethiopia'];
  List<String> get texts => _texts;
  set texts(List<String> value) {
    _texts = value;
  }

  void addToTexts(String value) {
    texts.add(value);
  }

  void removeFromTexts(String value) {
    texts.remove(value);
  }

  void removeAtIndexFromTexts(int index) {
    texts.removeAt(index);
  }

  void updateTextsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    texts[index] = updateFn(_texts[index]);
  }

  void insertAtIndexInTexts(int index, String value) {
    texts.insert(index, value);
  }

  bool _liked = false;
  bool get liked => _liked;
  set liked(bool value) {
    _liked = value;
  }

  bool _recordingaudio = false;
  bool get recordingaudio => _recordingaudio;
  set recordingaudio(bool value) {
    _recordingaudio = value;
  }

  final _appqueriesManager = FutureRequestManager<List<FeedyourcuriosityRow>>();
  Future<List<FeedyourcuriosityRow>> appqueries({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<FeedyourcuriosityRow>> Function() requestFn,
  }) =>
      _appqueriesManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearAppqueriesCache() => _appqueriesManager.clear();
  void clearAppqueriesCacheKey(String? uniqueKey) =>
      _appqueriesManager.clearRequest(uniqueKey);

  final _appManager = FutureRequestManager<List<TopReadArticlesRow>>();
  Future<List<TopReadArticlesRow>> app({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<TopReadArticlesRow>> Function() requestFn,
  }) =>
      _appManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearAppCache() => _appManager.clear();
  void clearAppCacheKey(String? uniqueKey) =>
      _appManager.clearRequest(uniqueKey);

  final _queryManager = FutureRequestManager<List<InvestmentNewsRow>>();
  Future<List<InvestmentNewsRow>> query({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<InvestmentNewsRow>> Function() requestFn,
  }) =>
      _queryManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearQueryCache() => _queryManager.clear();
  void clearQueryCacheKey(String? uniqueKey) =>
      _queryManager.clearRequest(uniqueKey);

  final _querrrManager = FutureRequestManager<List<EditorrecommendationRow>>();
  Future<List<EditorrecommendationRow>> querrr({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<EditorrecommendationRow>> Function() requestFn,
  }) =>
      _querrrManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearQuerrrCache() => _querrrManager.clear();
  void clearQuerrrCacheKey(String? uniqueKey) =>
      _querrrManager.clearRequest(uniqueKey);

  final _fycManager = FutureRequestManager<List<FeedYourCuriosityTopicsRow>>();
  Future<List<FeedYourCuriosityTopicsRow>> fyc({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<FeedYourCuriosityTopicsRow>> Function() requestFn,
  }) =>
      _fycManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearFycCache() => _fycManager.clear();
  void clearFycCacheKey(String? uniqueKey) =>
      _fycManager.clearRequest(uniqueKey);

  final _apppManager = FutureRequestManager<List<CountryProfilesRow>>();
  Future<List<CountryProfilesRow>> appp({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<CountryProfilesRow>> Function() requestFn,
  }) =>
      _apppManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearApppCache() => _apppManager.clear();
  void clearApppCacheKey(String? uniqueKey) =>
      _apppManager.clearRequest(uniqueKey);

  final _reelsManager = FutureRequestManager<List<ShortVideosRow>>();
  Future<List<ShortVideosRow>> reels({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<ShortVideosRow>> Function() requestFn,
  }) =>
      _reelsManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearReelsCache() => _reelsManager.clear();
  void clearReelsCacheKey(String? uniqueKey) =>
      _reelsManager.clearRequest(uniqueKey);

  final _countrynewsManager =
      FutureRequestManager<List<CountryProfileNewsRow>>();
  Future<List<CountryProfileNewsRow>> countrynews({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<CountryProfileNewsRow>> Function() requestFn,
  }) =>
      _countrynewsManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearCountrynewsCache() => _countrynewsManager.clear();
  void clearCountrynewsCacheKey(String? uniqueKey) =>
      _countrynewsManager.clearRequest(uniqueKey);

  final _topicsManager =
      FutureRequestManager<List<InvestementNewsArticlesRow>>();
  Future<List<InvestementNewsArticlesRow>> topics({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<InvestementNewsArticlesRow>> Function() requestFn,
  }) =>
      _topicsManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearTopicsCache() => _topicsManager.clear();
  void clearTopicsCacheKey(String? uniqueKey) =>
      _topicsManager.clearRequest(uniqueKey);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
