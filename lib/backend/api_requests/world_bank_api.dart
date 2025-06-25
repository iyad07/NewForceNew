import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

class WorldBankApiService {
  static const String baseUrl = 'https://api.worldbank.org/v2';
  
  // Get GDP data for African countries
  static Future<ApiCallResponse> getGDPData({
    String? countryCode = 'ZA', // Default to South Africa
    String? startYear = '2017',
    String? endYear = '2024',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getGDPData',
      apiUrl: '$baseUrl/country/$countryCode/indicator/NY.GDP.MKTP.CD?date=$startYear:$endYear&format=json&per_page=100',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      returnBody: true,
      decodeUtf8: true,
    );
  }
  
  // Get unemployment rate data
  static Future<ApiCallResponse> getUnemploymentData({
    String? countryCode = 'ZA',
    String? startYear = '2017', 
    String? endYear = '2024',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getUnemploymentData',
      apiUrl: '$baseUrl/country/$countryCode/indicator/SL.UEM.TOTL.ZS?date=$startYear:$endYear&format=json&per_page=100',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      returnBody: true,
      decodeUtf8: true,
    );
  }
  
  // Get inflation rate data
  static Future<ApiCallResponse> getInflationData({
    String? countryCode = 'ZA',
    String? startYear = '2017',
    String? endYear = '2024', 
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getInflationData',
      apiUrl: '$baseUrl/country/$countryCode/indicator/FP.CPI.TOTL.ZG?date=$startYear:$endYear&format=json&per_page=100',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      returnBody: true,
      decodeUtf8: true,
    );
  }
  
  // Get trade data (exports)
  static Future<ApiCallResponse> getExportsData({
    String? countryCode = 'ZA',
    String? startYear = '2017',
    String? endYear = '2024',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getExportsData',
      apiUrl: '$baseUrl/country/$countryCode/indicator/NE.EXP.GNFS.CD?date=$startYear:$endYear&format=json&per_page=100',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      returnBody: true,
      decodeUtf8: true,
    );
  }
  
  // Get trade data (imports)
  static Future<ApiCallResponse> getImportsData({
    String? countryCode = 'ZA',
    String? startYear = '2017',
    String? endYear = '2024',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getImportsData',
      apiUrl: '$baseUrl/country/$countryCode/indicator/NE.IMP.GNFS.CD?date=$startYear:$endYear&format=json&per_page=100',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      returnBody: true,
      decodeUtf8: true,
    );
  }
  
  // Get agriculture value added data
  static Future<ApiCallResponse> getAgricultureData({
    String? countryCode = 'ZA',
    String? startYear = '2017',
    String? endYear = '2024',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getAgricultureData',
      apiUrl: '$baseUrl/country/$countryCode/indicator/NV.AGR.TOTL.ZS?date=$startYear:$endYear&format=json&per_page=100',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      returnBody: true,
      decodeUtf8: true,
    );
  }
  
  // Get energy use data
  static Future<ApiCallResponse> getEnergyData({
    String? countryCode = 'ZA',
    String? startYear = '2017',
    String? endYear = '2024',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getEnergyData',
      apiUrl: '$baseUrl/country/$countryCode/indicator/EG.USE.PCAP.KG.OE?date=$startYear:$endYear&format=json&per_page=100',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      returnBody: true,
      decodeUtf8: true,
    );
  }
  
  // Get Foreign Direct Investment (FDI) data
  static Future<ApiCallResponse> getFDIData({
    String? countryCode = 'ZA',
    String? startYear = '2017',
    String? endYear = '2024',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getFDIData',
      apiUrl: '$baseUrl/country/$countryCode/indicator/BX.KLT.DINV.CD.WD?date=$startYear:$endYear&format=json&per_page=100',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      returnBody: true,
      decodeUtf8: true,
    );
  }
  
  // Get multiple African countries data
  static Future<ApiCallResponse> getAfricanCountriesData({
    String? indicator = 'NY.GDP.MKTP.CD',
    String? startYear = '2017',
    String? endYear = '2024',
  }) async {
    // African country codes: South Africa, Nigeria, Kenya, Ghana, Egypt
    const africanCountries = 'ZA;NG;KE;GH;EG';
    
    return ApiManager.instance.makeApiCall(
      callName: 'getAfricanCountriesData',
      apiUrl: '$baseUrl/country/$africanCountries/indicator/$indicator?date=$startYear:$endYear&format=json&per_page=500',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      returnBody: true,
      decodeUtf8: true,
    );
  }
  
  // Parse World Bank API response
  static List<Map<String, dynamic>> parseWorldBankResponse(String responseBody) {
    try {
      final List<dynamic> jsonResponse = json.decode(responseBody);
      
      // World Bank API returns an array where the second element contains the data
      if (jsonResponse.length > 1 && jsonResponse[1] is List) {
        return List<Map<String, dynamic>>.from(jsonResponse[1]);
      }
      
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing World Bank response: $e');
      }
      return [];
    }
  }
  
  // Get latest value from parsed data
  static double? getLatestValue(List<Map<String, dynamic>> data) {
    for (var item in data) {
      if (item['value'] != null) {
        return double.tryParse(item['value'].toString());
      }
    }
    return null;
  }
  
  // Format large numbers (billions, millions)
  static String formatLargeNumber(double? value) {
    if (value == null) return 'N/A';
    
    if (value >= 1e12) {
      return '\$${(value / 1e12).toStringAsFixed(1)}T';
    } else if (value >= 1e9) {
      return '\$${(value / 1e9).toStringAsFixed(1)}B';
    } else if (value >= 1e6) {
      return '\$${(value / 1e6).toStringAsFixed(1)}M';
    } else {
      return '\$${value.toStringAsFixed(0)}';
    }
  }
  
  // Format percentage values
  static String formatPercentage(double? value) {
    if (value == null) return 'N/A';
    return '${value.toStringAsFixed(1)}%';
  }
}

// Data models for World Bank indicators
class EconomicIndicator {
  final String countryName;
  final String countryCode;
  final String indicatorName;
  final String indicatorCode;
  final String year;
  final double? value;
  
  EconomicIndicator({
    required this.countryName,
    required this.countryCode,
    required this.indicatorName,
    required this.indicatorCode,
    required this.year,
    this.value,
  });
  
  factory EconomicIndicator.fromJson(Map<String, dynamic> json) {
    return EconomicIndicator(
      countryName: json['country']?['value'] ?? '',
      countryCode: json['countryiso3code'] ?? '',
      indicatorName: json['indicator']?['value'] ?? '',
      indicatorCode: json['indicator']?['id'] ?? '',
      year: json['date'] ?? '',
      value: json['value'] != null ? double.tryParse(json['value'].toString()) : null,
    );
  }
}