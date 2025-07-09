import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_model.dart';
import 'investment_page_widget.dart' show InvestmentPageWidget;
import '/backend/api_requests/world_bank_api.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartData {
  final List<FlSpot> gdpSpots;
  final List<FlSpot> fdiSpots;
  final Map<int, double> rawGdpValues;
  final Map<int, double> rawFdiValues;
  final double latestGDP;
  final double latestFDI;
  final double latestInflation;
  final DateTime cacheTime;

  ChartData({
    required this.gdpSpots,
    required this.fdiSpots,
    required this.rawGdpValues,
    required this.rawFdiValues,
    required this.latestGDP,
    required this.latestFDI,
    required this.latestInflation,
    required this.cacheTime,
  });

  bool get isExpired {
    // Cache expires after 30 minutes
    return DateTime.now().difference(cacheTime).inMinutes > 30;
  }
}

class InvestmentPageModel extends FlutterFlowModel<InvestmentPageWidget> {
  ChartData? _cachedChartData;
  ChartData? _cachedEconomicData;
  
  // Cache duration in minutes
  static const int cacheDurationMinutes = 30;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    _cachedChartData = null;
    _cachedEconomicData = null;
  }

  // Get cached chart data or fetch new data
  Future<ChartData> getChartData({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedChartData != null && !_cachedChartData!.isExpired) {
      debugPrint('Using cached chart data');
      return _cachedChartData!;
    }

    debugPrint('Fetching fresh chart data');
    
    try {
      final responses = await Future.wait([
        WorldBankApiService.getAfricanCountriesData(
          indicator: 'NY.GDP.MKTP.CD', // GDP indicator
          startYear: '2020',
          endYear: '2024',
        ),
        WorldBankApiService.getAfricanCountriesData(
          indicator: 'BX.KLT.DINV.CD.WD', // FDI indicator
          startYear: '2020',
          endYear: '2024',
        ),
      ]);

      final chartData = await _processChartData(responses);
      _cachedChartData = chartData;
      return chartData;
    } catch (e) {
      debugPrint('Error fetching chart data: $e');
      // Return fallback data if API fails
      return _getFallbackChartData();
    }
  }

  // Get cached economic indicators or fetch new data
  Future<ChartData> getEconomicData({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedEconomicData != null && !_cachedEconomicData!.isExpired) {
      debugPrint('Using cached economic data');
      return _cachedEconomicData!;
    }

    debugPrint('Fetching fresh economic data');
    
    try {
      final responses = await Future.wait([
        WorldBankApiService.getAfricanCountriesData(
          indicator: 'NY.GDP.MKTP.CD', // GDP indicator
          startYear: '2020',
          endYear: '2024',
        ),
        WorldBankApiService.getAfricanCountriesData(
          indicator: 'BX.KLT.DINV.CD.WD', // FDI indicator
          startYear: '2020',
          endYear: '2024',
        ),
        WorldBankApiService.getAfricanCountriesData(
          indicator: 'FP.CPI.TOTL.ZG', // Inflation indicator
          startYear: '2020',
          endYear: '2024',
        ),
      ]);

      final economicData = await _processEconomicData(responses);
      _cachedEconomicData = economicData;
      return economicData;
    } catch (e) {
      debugPrint('Error fetching economic data: $e');
      // Return fallback data if API fails
      return _getFallbackEconomicData();
    }
  }

  Future<ChartData> _processChartData(List<ApiCallResponse> responses) async {
    List<FlSpot> gdpSpots = [];
    List<FlSpot> fdiSpots = [];
    Map<int, double> rawGdpValues = {};
    Map<int, double> rawFdiValues = {};
    List<String> years = ['2020', '2021', '2022', '2023'];

    // Process GDP data
    try {
      final gdpResponse = responses[0];
      if (gdpResponse.jsonBody != null) {
        final data = gdpResponse.jsonBody;
        if (data is List && data.length > 1 && data[1] is List) {
          final gdpData = data[1] as List;
          Map<String, double> yearlyGDP = {};
          
          for (var item in gdpData) {
            if (item != null && item['date'] != null && item['value'] != null) {
              String year = item['date'].toString();
              double value = (item['value'] as num).toDouble();
              yearlyGDP[year] = (yearlyGDP[year] ?? 0) + value;
            }
          }

          List<double> gdpValuesForNormalization = [];
          for (String year in years) {
            if (yearlyGDP.containsKey(year)) {
              gdpValuesForNormalization.add(yearlyGDP[year]! / 1000000000000);
            }
          }

          if (gdpValuesForNormalization.isNotEmpty) {
            double minGdp = gdpValuesForNormalization.reduce((a, b) => a < b ? a : b);
            double maxGdp = gdpValuesForNormalization.reduce((a, b) => a > b ? a : b);

            for (int i = 0; i < years.length; i++) {
              String year = years[i];
              if (yearlyGDP.containsKey(year)) {
                double rawValue = yearlyGDP[year]! / 1000000000000;
                rawGdpValues[i] = rawValue;
                double normalizedValue = ((rawValue - minGdp) / (maxGdp - minGdp)) * 80 + 10;
                gdpSpots.add(FlSpot(i.toDouble(), normalizedValue));
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error processing GDP data: $e');
    }

    // Process FDI data
    try {
      final fdiResponse = responses[1];
      if (fdiResponse.jsonBody != null) {
        final data = fdiResponse.jsonBody;
        if (data is List && data.length > 1 && data[1] is List) {
          final fdiData = data[1] as List;
          Map<String, double> yearlyFDI = {};
          
          for (var item in fdiData) {
            if (item != null && item['date'] != null && item['value'] != null) {
              String year = item['date'].toString();
              double value = (item['value'] as num).toDouble();
              yearlyFDI[year] = (yearlyFDI[year] ?? 0) + value;
            }
          }

          List<double> fdiValuesForNormalization = [];
          for (String year in years) {
            if (yearlyFDI.containsKey(year)) {
              fdiValuesForNormalization.add(yearlyFDI[year]! / 1000000000);
            }
          }

          if (fdiValuesForNormalization.isNotEmpty) {
            double minFdi = fdiValuesForNormalization.reduce((a, b) => a < b ? a : b);
            double maxFdi = fdiValuesForNormalization.reduce((a, b) => a > b ? a : b);

            for (int i = 0; i < years.length; i++) {
              String year = years[i];
              if (yearlyFDI.containsKey(year)) {
                double rawValue = yearlyFDI[year]! / 1000000000;
                rawFdiValues[i] = rawValue;
                double normalizedValue = ((rawValue - minFdi) / (maxFdi - minFdi)) * 80 + 10;
                fdiSpots.add(FlSpot(i.toDouble(), normalizedValue));
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error processing FDI data: $e');
    }

    // Use fallback data if processing failed
    if (gdpSpots.isEmpty) {
      gdpSpots = [FlSpot(0, 25.0), FlSpot(1, 85.0), FlSpot(2, 90.0), FlSpot(3, 20.0)];
    }
    if (fdiSpots.isEmpty) {
      fdiSpots = [FlSpot(0, 15.0), FlSpot(1, 95.0), FlSpot(2, 45.0), FlSpot(3, 35.0)];
    }

    return ChartData(
      gdpSpots: gdpSpots,
      fdiSpots: fdiSpots,
      rawGdpValues: rawGdpValues,
      rawFdiValues: rawFdiValues,
      latestGDP: 0.0, // Not used for chart data
      latestFDI: 0.0, // Not used for chart data
      latestInflation: 0.0, // Not used for chart data
      cacheTime: DateTime.now(),
    );
  }

  Future<ChartData> _processEconomicData(List<ApiCallResponse> responses) async {
    final gdpResponse = responses[0];
    final fdiResponse = responses[1];
    final inflationResponse = responses[2];

    final gdpData = gdpResponse.succeeded
        ? WorldBankApiService.parseWorldBankResponse(gdpResponse.bodyText)
        : <Map<String, dynamic>>[];
    final fdiData = fdiResponse.succeeded
        ? WorldBankApiService.parseWorldBankResponse(fdiResponse.bodyText)
        : <Map<String, dynamic>>[];
    final inflationData = inflationResponse.succeeded
        ? WorldBankApiService.parseWorldBankResponse(inflationResponse.bodyText)
        : <Map<String, dynamic>>[];

    final totalGDP = _calculateContinentTotal(gdpData);
    final totalFDI = _calculateContinentTotal(fdiData);
    final avgInflation = _calculateContinentAverage(inflationData);

    return ChartData(
      gdpSpots: [], // Not used for economic data
      fdiSpots: [], // Not used for economic data
      rawGdpValues: {}, // Not used for economic data
      rawFdiValues: {}, // Not used for economic data
      latestGDP: totalGDP,
      latestFDI: totalFDI,
      latestInflation: avgInflation,
      cacheTime: DateTime.now(),
    );
  }

  // Calculate total value across all African countries (for GDP and FDI)
  double _calculateContinentTotal(List<Map<String, dynamic>> data) {
    double total = 0.0;
    Map<String, double> latestByCountry = {};
    
    // Get the latest value for each country
    for (var item in data) {
      if (item['value'] != null && item['countryiso3code'] != null) {
        String countryCode = item['countryiso3code'];
        double value = double.tryParse(item['value'].toString()) ?? 0.0;
        
        // Keep only the latest value for each country
        if (!latestByCountry.containsKey(countryCode) || 
            (item['date'] != null && _isMoreRecent(item['date'], latestByCountry, countryCode))) {
          latestByCountry[countryCode] = value;
        }
      }
    }
    
    // Sum all country values
    for (double value in latestByCountry.values) {
      total += value;
    }
    
    return total;
  }

  // Calculate average value across all African countries (for inflation)
  double _calculateContinentAverage(List<Map<String, dynamic>> data) {
    Map<String, double> latestByCountry = {};
    
    // Get the latest value for each country
    for (var item in data) {
      if (item['value'] != null && item['countryiso3code'] != null) {
        String countryCode = item['countryiso3code'];
        double value = double.tryParse(item['value'].toString()) ?? 0.0;
        
        // Keep only the latest value for each country
        if (!latestByCountry.containsKey(countryCode) || 
            (item['date'] != null && _isMoreRecent(item['date'], latestByCountry, countryCode))) {
          latestByCountry[countryCode] = value;
        }
      }
    }
    
    if (latestByCountry.isEmpty) return 0.0;
    
    // Calculate average
    double sum = latestByCountry.values.reduce((a, b) => a + b);
    return sum / latestByCountry.length;
  }

  // Helper method to check if a date is more recent
  bool _isMoreRecent(String date, Map<String, double> latestByCountry, String countryCode) {
    // Simple year comparison - in real implementation you might want more sophisticated date parsing
    try {
      int year = int.parse(date);
      // This is a simplified check - assumes we want the most recent year
      return true; // For now, let the natural order of API response determine latest
    } catch (e) {
      return false;
    }
  }

  ChartData _getFallbackChartData() {
    return ChartData(
      gdpSpots: [FlSpot(0, 25.0), FlSpot(1, 85.0), FlSpot(2, 90.0), FlSpot(3, 20.0)],
      fdiSpots: [FlSpot(0, 15.0), FlSpot(1, 95.0), FlSpot(2, 45.0), FlSpot(3, 35.0)],
      rawGdpValues: {0: 2.5, 1: 8.5, 2: 9.0, 3: 2.0},
      rawFdiValues: {0: 1.5, 1: 9.5, 2: 4.5, 3: 3.5},
      latestGDP: 0.0,
      latestFDI: 0.0,
      latestInflation: 0.0,
      cacheTime: DateTime.now(),
    );
  }

  ChartData _getFallbackEconomicData() {
    return ChartData(
      gdpSpots: [],
      fdiSpots: [],
      rawGdpValues: {},
      rawFdiValues: {},
      latestGDP: 2500000000000.0, // Combined African countries GDP fallback
      latestFDI: 45000000000.0,   // Combined African countries FDI fallback
      latestInflation: 8.5,       // Average African countries inflation fallback
      cacheTime: DateTime.now(),
    );
  }

  // Clear cache manually
  void clearCache() {
    _cachedChartData = null;
    _cachedEconomicData = null;
    debugPrint('Cache cleared');
  }

  // Check if data is cached
  bool get hasValidChartCache => _cachedChartData != null && !_cachedChartData!.isExpired;
  bool get hasValidEconomicCache => _cachedEconomicData != null && !_cachedEconomicData!.isExpired;
  
  // Public getters for cached data
  ChartData? get cachedChartData => _cachedChartData;
  ChartData? get cachedEconomicData => _cachedEconomicData;
}