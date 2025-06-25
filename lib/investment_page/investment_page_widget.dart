// investment_page_widget.dart - Updated with investment UI style
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// import '../backend/supabase/supabase.dart'; // Unused import
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
// import '../flutter_flow/flutter_flow_charts.dart'; // File not found, using fl_chart directly
import '/backend/api_requests/world_bank_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import 'investment_page_model.dart';
export 'investment_page_model.dart';

class InvestmentPageWidget extends StatefulWidget {
  const InvestmentPageWidget({super.key});

  @override
  State<InvestmentPageWidget> createState() => _InvestmentPageWidgetState();
}

class _InvestmentPageWidgetState extends State<InvestmentPageWidget>
    with TickerProviderStateMixin {
  late InvestmentPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InvestmentPageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF1E2022),
        body: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF222426), Color(0xFF121416)],
                stops: [0.0, 1.0],
                begin: AlignmentDirectional(1.0, -0.34),
                end: AlignmentDirectional(-1.0, 0.34),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header Section
                    Material(
                      color: Colors.transparent,
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 80.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0x2C7E5F1A), Color(0xFF201D1B)],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(0.59, -1.0),
                            end: AlignmentDirectional(-0.59, 1.0),
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Investment Page',
                                style: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .override(
                                      fontFamily: 'SF Pro Display',
                                      useGoogleFonts: false,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      //fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Material(
                                color: Colors.transparent,
                                elevation: 1.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Container(
                                  width: 150.0,
                                  height: 32.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEF9A39),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    'Explore Africa Now',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          fontFamily: 'SF Pro Display',
                                                     useGoogleFonts: false,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0),

                    // Market Trends Section
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Continent Market Trends',
                            style: FlutterFlowTheme.of(context)
                                .labelLarge
                                .override(
                                  fontFamily: 'SF Pro Display',
                                   useGoogleFonts: false,
                                   fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  //fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'Last 5 years ',
                            style: FlutterFlowTheme.of(context)
                                .labelLarge
                                .override(
                                  fontFamily: 'SF Pro Display',
                                   useGoogleFonts: false,
                                   fontWeight: FontWeight.normal,
                                  color: Color(0xFF00FF0C),
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 32.0, // Full width minus padding
                            height: 200.0, // Increased height for better visibility
                            child: FutureBuilder<List<ApiCallResponse>>(
                              future: Future.wait([
                                WorldBankApiService.getAfricanCountriesData(
                                  indicator: 'NY.GDP.MKTP.CD', // GDP indicator
                                  startYear: '2020',
                                  endYear: '2024',
                                ).then((response) {
                                  debugPrint('GDP API Response: ${response.jsonBody}');
                                  return response;
                                }),
                                WorldBankApiService.getAfricanCountriesData(
                                  indicator: 'BX.KLT.DINV.CD.WD', // FDI indicator
                                  startYear: '2020',
                                  endYear: '2024',
                                ).then((response) {
                                  debugPrint('FDI API Response: ${response.jsonBody}');
                                  return response;
                                }),
                              ]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF39EF8C),
                                    ),
                                  );
                                }
                                
                                List<FlSpot> gdpSpots = [];
                                List<FlSpot> fdiSpots = [];
                                String displayPeriod = 'Last 5 years'; // Display period
                                
                                if (snapshot.hasData && snapshot.data != null) {
                                  // Parse GDP data for African continent
                                  try {
                                    final gdpResponse = snapshot.data![0];
                                    if (gdpResponse.jsonBody != null) {
                                      final data = gdpResponse.jsonBody;
                                      if (data is List && data.length > 1 && data[1] is List) {
                                        final gdpData = data[1] as List;
                                        
                                        // Group data by year and sum values across all African countries
                                        Map<String, double> yearlyGDP = {};
                                        for (var item in gdpData) {
                                          if (item != null && item['date'] != null && item['value'] != null) {
                                            String year = item['date'].toString();
                                            double value = (item['value'] as num).toDouble();
                                            yearlyGDP[year] = (yearlyGDP[year] ?? 0) + value;
                                          }
                                        }
                                        
                                        debugPrint('Available GDP years: ${yearlyGDP.keys.toList()}');
                                        
                                        // Create 5-year chart points (2020-2024)
                                        List<String> years = ['2020', '2021', '2022', '2023', '2024'];
                                        for (int i = 0; i < years.length; i++) {
                                          String year = years[i];
                                          if (yearlyGDP.containsKey(year)) {
                                            double gdpValue = yearlyGDP[year]! / 1000000000000; // Convert to trillions
                                            gdpSpots.add(FlSpot(i.toDouble(), gdpValue));
                                            debugPrint('GDP $year: $gdpValue trillion');
                                          }
                                        }

                                      }
                                    }
                                  } catch (e) {
                                    debugPrint('Error parsing GDP data: $e');
                                  }
                                  
                                  // Parse FDI data for African continent
                                  try {
                                    final fdiResponse = snapshot.data![1];
                                    if (fdiResponse.jsonBody != null) {
                                      final data = fdiResponse.jsonBody;
                                      if (data is List && data.length > 1 && data[1] is List) {
                                        final fdiData = data[1] as List;
                                        
                                        // Group data by year and sum values across all African countries
                                        Map<String, double> yearlyFDI = {};
                                        for (var item in fdiData) {
                                          if (item != null && item['date'] != null && item['value'] != null) {
                                            String year = item['date'].toString();
                                            double value = (item['value'] as num).toDouble();
                                            yearlyFDI[year] = (yearlyFDI[year] ?? 0) + value;
                                          }
                                        }
                                        
                                        debugPrint('Available FDI years: ${yearlyFDI.keys.toList()}');
                                        
                                        // Create 5-year chart points (2020-2024)
                                        List<String> years = ['2020', '2021', '2022', '2023', '2024'];
                                        for (int i = 0; i < years.length; i++) {
                                          String year = years[i];
                                          if (yearlyFDI.containsKey(year)) {
                                            double fdiValue = yearlyFDI[year]! / 1000000000; // Convert to billions
                                            fdiSpots.add(FlSpot(i.toDouble(), fdiValue));
                                            debugPrint('FDI $year: $fdiValue billion');
                                          }
                                        }
                                      }
                                    }
                                  } catch (e) {
                                    debugPrint('Error parsing FDI data: $e');
                                  }
                                }
                                
                                // Fallback to sample data if API fails (African continent 2020-2024)
                                if (gdpSpots.isEmpty) {
                                  gdpSpots = [
                                    FlSpot(0, 2.8), // 2020 - $2.8T
                                    FlSpot(1, 2.9), // 2021 - $2.9T
                                    FlSpot(2, 3.1), // 2022 - $3.1T
                                    FlSpot(3, 3.3), // 2023 - $3.3T
                                    FlSpot(4, 3.5), // 2024 - $3.5T
                                  ];
                                }
                                
                                if (fdiSpots.isEmpty) {
                                  fdiSpots = [
                                    FlSpot(0, 38.5), // 2020 - $38.5B
                                    FlSpot(1, 42.1), // 2021 - $42.1B
                                    FlSpot(2, 48.3), // 2022 - $48.3B
                                    FlSpot(3, 52.7), // 2023 - $52.7B
                                    FlSpot(4, 58.2), // 2024 - $58.2B
                                  ];
                                }
                                
                                return LineChart(
                                  LineChartData(
                                    gridData: FlGridData(
                                      show: false, // Removed grid lines
                                    ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                                minX: 0,
                                maxX: 4, // 5 data points (0-4) for 2020-2024 data
                                minY: 0,
                                maxY: null, // Auto-scale based on data
                                    lineBarsData: [
                                      // GDP Line (Green)
                                      LineChartBarData(
                                        spots: gdpSpots,
                                        isCurved: true,
                                        color: Color(0xFF39EF8C),
                                        barWidth: 2,
                                        isStrokeCapRound: true,
                                        dotData: FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: Color(0xFF39EF8C).withValues(alpha: 0.1),
                                        ),
                                      ),
                                      // FDI Line (Red)
                                      LineChartBarData(
                                        spots: fdiSpots,
                                        isCurved: true,
                                        color: Color(0xFFCC2929),
                                        barWidth: 2,
                                        isStrokeCapRound: true,
                                        dotData: FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: Color(0xFFCC2929).withValues(alpha: 0.1),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          // Chart Legend
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF39EF8C),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Africa GDP (Last 5yrs)',
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 24),
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFCC2929),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Africa FDI (Last 5yrs)',
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ].divide(SizedBox(height: 5.0)),
                      ),
                    ),

                    // Economic Indicators with World Bank API
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FutureBuilder<List<ApiCallResponse>>(
                        future: Future.wait([
                          WorldBankApiService.getGDPData(
                            countryCode: 'ZA',
                            startYear: '2020',
                            endYear: '2024',
                          ),
                          WorldBankApiService.getUnemploymentData(
                            countryCode: 'ZA',
                            startYear: '2020',
                            endYear: '2024',
                          ),
                          WorldBankApiService.getInflationData(
                            countryCode: 'ZA',
                            startYear: '2020',
                            endYear: '2024',
                          ),
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: SpinKitFadingCircle(
                                  color: Color(0xFFFF8D07),
                                  size: 50.0,
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasError || !snapshot.hasData) {
                            return _buildDefaultIndicators();
                          }

                          final responses = snapshot.data!;
                          final gdpResponse = responses[0];
                          final unemploymentResponse = responses[1];
                          final inflationResponse = responses[2];

                          // Parse World Bank API responses
                          final gdpData = gdpResponse.succeeded
                              ? WorldBankApiService.parseWorldBankResponse(
                                  gdpResponse.bodyText)
                              : <Map<String, dynamic>>[];
                          final unemploymentData = unemploymentResponse.succeeded
                              ? WorldBankApiService.parseWorldBankResponse(
                                  unemploymentResponse.bodyText)
                              : <Map<String, dynamic>>[];
                          final inflationData = inflationResponse.succeeded
                              ? WorldBankApiService.parseWorldBankResponse(
                                  inflationResponse.bodyText)
                              : <Map<String, dynamic>>[];

                          // Get latest values
                          final latestGDP = WorldBankApiService.getLatestValue(gdpData);
                          final latestUnemployment =
                              WorldBankApiService.getLatestValue(unemploymentData);
                          final latestInflation =
                              WorldBankApiService.getLatestValue(inflationData);

                          return Row(
                            children: [
                              Expanded(
                                child: _buildEconomicCard(
                                  'GDP (USD \$)',
                                  WorldBankApiService.formatLargeNumber(latestGDP),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: _buildEconomicCard(
                                  'Unemployment Rate',
                                  WorldBankApiService.formatPercentage(latestUnemployment),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: _buildEconomicCard(
                                  'Inflation Rate',
                                  WorldBankApiService.formatPercentage(latestInflation),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 20.0),

                    // Business Index and Natural Resources Row
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  context.pushNamed('BusinessIndex');
                                },
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 1.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/Screenshot_2025-06-22_213055-removebg-preview.png',
                                            width: 128.8,
                                            height: 185.51,
                                            fit: BoxFit.cover,
                                          ),
                                          GradientText(
                                            'Business Index',
                                            style: FlutterFlowTheme.of(context)
                                                .titleSmall
                                                .override(
                                                  fontFamily: 'SF Pro Display',
                                                useGoogleFonts: false,
                                                  color: FlutterFlowTheme.of(context)
                                                      .secondary,
                                                  letterSpacing: 0.0,
                                                ),
                                            colors: [Color(0xFF5715AC), Color(0xFF47605D)],
                                            gradientDirection: GradientDirection.ltr,
                                            gradientType: GradientType.linear,
                                          ),
                                          Text(
                                            'Explore diverse sectors from tech startups to financial services.',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'SF Pro Display',
                                           useGoogleFonts: false,
                                                  color: Color(0xFFEFAF39),
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                          FFButtonWidget(
                                            onPressed: () {
                                              context.pushNamed('BusinessIndex');
                                            },
                                            text: 'Navigate the landscape',
                                            options: FFButtonOptions(
                                              height: 32.0,
                                              padding: EdgeInsets.all(8.0),
                                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                              color: Color(0xFFEF7D39),
                                              textStyle: FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .override(
                                                    fontFamily: 'SF Pro Display',
                                           useGoogleFonts: false,
                                                    color: Colors.white,
                                                    letterSpacing: 0.0,
                                                  ),
                                              elevation: 0.0,
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 12.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  context.pushNamed('naturalResources');
                                },
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 1.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/Screenshot_2025-06-22_195536-removebg-preview.png',
                                            width: 128.8,
                                            height: 185.5,
                                            fit: BoxFit.cover,
                                          ),
                                          GradientText(
                                            'Natural Resources',
                                            style: FlutterFlowTheme.of(context)
                                                .titleSmall
                                                .override(
                                                  fontFamily: 'SF Pro Display',
                                                useGoogleFonts: false,
                                                  color: FlutterFlowTheme.of(context)
                                                      .secondary,
                                                  letterSpacing: 0.0,
                                                ),
                                            colors: [Color(0xFF5715AC), Color(0xFF83B4AE)],
                                            gradientDirection: GradientDirection.ltr,
                                            gradientType: GradientType.linear,
                                          ),
                                          Text(
                                            'Discover opportunities in mining, energy, and agriculture.',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'SF Pro Display',
                             useGoogleFonts: false,
                                                  color: Color(0xFFEFAF39),
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                          FFButtonWidget(
                                            onPressed: () {
                                              context.pushNamed('naturalResources');
                                            },
                                            text: 'Discover Resources',
                                            options: FFButtonOptions(
                                              height: 32.0,
                                              padding: EdgeInsets.all(8.0),
                                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                              color: Color(0xFFEF7D39),
                                              textStyle: FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .override(
                                                    fontFamily: 'SF Pro Display',
                                                   useGoogleFonts: false,
                                                    color: Colors.white,
                                                    letterSpacing: 0.0,
                                                  ),
                                              elevation: 0.0,
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 12.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ),

                    // Influential Figures and Country Profile Row
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  context.pushNamed('ProminentPeople');
                                },
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 1.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/wmremove-transformed-removebg-preview_(1).png',
                                            width: 128.8,
                                            height: 185.5,
                                            fit: BoxFit.cover,
                                          ),
                                          GradientText(
                                            'Influential Figures',
                                            style: FlutterFlowTheme.of(context)
                                                .titleSmall
                                                .override(
                                                  fontFamily: 'SF Pro Display',
                                                  useGoogleFonts: false,
                                                  color: FlutterFlowTheme.of(context)
                                                      .secondary,
                                                  letterSpacing: 0.0,
                                                ),
                                            colors: [Color(0xFF5715AC), Color(0xFFA5BDBB)],
                                            gradientDirection: GradientDirection.ltr,
                                            gradientType: GradientType.linear,
                                          ),
                                          Text(
                                            'Learn from leading entrepreneurs and strategists.',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'SF Pro Display',
                                                  useGoogleFonts: false,
                                                  color: Color(0xFFEFAF39),
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                          FFButtonWidget(
                                            onPressed: () {
                                              context.pushNamed('ProminentPeople');
                                            },
                                            text: 'See the top Players',
                                            options: FFButtonOptions(
                                              height: 32.0,
                                              padding: EdgeInsets.all(8.0),
                                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                              color: Color(0xFFEF7D39),
                                              textStyle: FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .override(
                                                    fontFamily: 'SF Pro Display',
                                                    useGoogleFonts: false,
                                                    color: Colors.white,
                                                    letterSpacing: 0.0,
                                                  ),
                                              elevation: 0.0,
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 12.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  context.pushNamed('CountriesList');
                                },
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 1.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/Screenshot_2025-06-22_195558-removebg-preview.png',
                                            width: 128.8,
                                            height: 185.5,
                                            fit: BoxFit.contain,
                                          ),
                                          GradientText(
                                            'Country Profile',
                                            style: FlutterFlowTheme.of(context)
                                                .titleSmall
                                                .override(
                                                  fontFamily: 'SF Pro Display',
                                                  useGoogleFonts: false,
                                                  color: FlutterFlowTheme.of(context)
                                                      .secondary,
                                                  letterSpacing: 0.0,
                                                ),
                                            colors: [Color(0xFF5715AC), Color(0xFFD4D4D4)],
                                            gradientDirection: GradientDirection.ltr,
                                            gradientType: GradientType.linear,
                                          ),
                                          Text(
                                            'Stay informed with the latest information and metric on each country.',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'SF Pro Display',
                                                     useGoogleFonts: false,
                                                  color: Color(0xFFEFAF39),
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                          FFButtonWidget(
                                            onPressed: () {
                                              context.pushNamed('CountriesList');
                                            },
                                            text: 'View Insights',
                                            options: FFButtonOptions(
                                              height: 32.0,
                                              padding: EdgeInsets.all(8.0),
                                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                              color: Color(0xFFEF7D39),
                                              textStyle: FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .override(
                                                    fontFamily: 'SF Pro Display',
                                                   useGoogleFonts: false,
                                                    color: Colors.white,
                                                    letterSpacing: 0.0,
                                                  ),
                                              elevation: 0.0,
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 12.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ),
                  ].divide(SizedBox(height: 20.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEconomicCard(String title, String value) {
    return Material(
      color: Colors.transparent,
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: 100.0,
        height: 75.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'SF Pro Display',
                             useGoogleFonts: false,
                            color: Colors.white,
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'SF Pro Display',
                             useGoogleFonts: false,
                            color: Color(0xFF00FF24),
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultIndicators() {
    return Row(
      children: [
        Expanded(
          child: _buildEconomicCard('GDP (USD \$)', '\$398B'),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: _buildEconomicCard('Unemployment', '28.5%'),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: _buildEconomicCard('Inflation', '5.2%'),
        ),
      ],
    );
  }
}

// Custom painter for miniature graph (from original investment page)
class MiniGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4A90E2)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    
    final redPaint = Paint()
      ..color = const Color(0xFFFF6B6B)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    
    final greenPaint = Paint()
      ..color = const Color(0xFF4ECDC4)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    
    // Create zigzag line pattern similar to the image
    final path1 = Path();
    final path2 = Path();
    final path3 = Path();
    
    // Blue line (top)
    path1.moveTo(0, size.height * 0.3);
    path1.lineTo(size.width * 0.2, size.height * 0.2);
    path1.lineTo(size.width * 0.4, size.height * 0.4);
    path1.lineTo(size.width * 0.6, size.height * 0.1);
    path1.lineTo(size.width * 0.8, size.height * 0.3);
    path1.lineTo(size.width, size.height * 0.2);
    
    // Red line (middle)
    path2.moveTo(0, size.height * 0.6);
    path2.lineTo(size.width * 0.2, size.height * 0.5);
    path2.lineTo(size.width * 0.4, size.height * 0.7);
    path2.lineTo(size.width * 0.6, size.height * 0.4);
    path2.lineTo(size.width * 0.8, size.height * 0.6);
    path2.lineTo(size.width, size.height * 0.5);
    
    // Green line (bottom)
    path3.moveTo(0, size.height * 0.8);
    path3.lineTo(size.width * 0.2, size.height * 0.9);
    path3.lineTo(size.width * 0.4, size.height * 0.7);
    path3.lineTo(size.width * 0.6, size.height * 0.8);
    path3.lineTo(size.width * 0.8, size.height * 0.9);
    path3.lineTo(size.width, size.height * 0.8);
    
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, redPaint);
    canvas.drawPath(path3, greenPaint);
    
    // Add small dots at key points
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.1), 2, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.3), 2, dotPaint);
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for the mini chart in Country Profile card
class MiniChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Create a simple line chart
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.4),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width, size.height * 0.1),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    // Draw dots at each point
    final dotPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 2.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}