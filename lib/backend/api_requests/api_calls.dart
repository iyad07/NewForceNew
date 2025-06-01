import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class SearchNewsArticlesCall {
  static Future<ApiCallResponse> call({
    String? searchString = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'searchNewsArticles',
      apiUrl:
          'https://etrgasxxhvyskoekhalf.supabase.co/rest/v1/feedYourCuriosityTopics?newsDescription=ilike.*$searchString*&select=*',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV0cmdhc3h4aHZ5c2tvZWtoYWxmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg3MTQwMDIsImV4cCI6MjAzNDI5MDAwMn0.QpCYCSFwk06mFusW_V93GsqcJ5eAHIpVhi2yrjpHdr0',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV0cmdhc3h4aHZ5c2tvZWtoYWxmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg3MTQwMDIsImV4cCI6MjAzNDI5MDAwMn0.QpCYCSFwk06mFusW_V93GsqcJ5eAHIpVhi2yrjpHdr0',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
