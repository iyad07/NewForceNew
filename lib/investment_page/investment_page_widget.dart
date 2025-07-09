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
  
  // Add refresh key to force FutureBuilder to rebuild
  Key _refreshKey = UniqueKey();
  
  // Animation controllers for chart lines
  late AnimationController _gdpLineController;
  late AnimationController _fdiLineController;
  late Animation<double> _gdpLineAnimation;
  late Animation<double> _fdiLineAnimation;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InvestmentPageModel());
    
    // Initialize animation controllers
    _gdpLineController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fdiLineController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Create animations with curves
    _gdpLineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _gdpLineController,
      curve: Curves.easeInOut,
    ));
    
    _fdiLineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fdiLineController,
      curve: Curves.easeInOut,
    ));
    
    // Don't start animations immediately - wait for data to load
  }
  
  void _startAnimations() {
    _gdpLineController.forward();
    
    // Start FDI animation 500ms after GDP
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _fdiLineController.forward();
      }
    });
  }
  
  void _resetAnimations() {
    _gdpLineController.reset();
    _fdiLineController.reset();
    // Don't start animations immediately - let data loading trigger them
  }

  @override
  void dispose() {
    _gdpLineController.dispose();
    _fdiLineController.dispose();
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
                            mainAxisAlignment: MainAxisAlignment.center,
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
                              /*Material(
                                color: Colors.transparent,
                                elevation: 1.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // Clear cache, refresh the World Bank data and reset animations
                                    _model.clearCache();
                                    setState(() {
                                      _refreshKey = UniqueKey();
                                    });
                                    _resetAnimations();
                                  },
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Container(
                                    width: 150.0,
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEF9A39),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.refresh,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          size: 16.0,
                                        ),
                                        SizedBox(width: 4.0),
                                        Text(
                                          'Refresh Data',
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),*/
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0),

                    // Market Trends Section
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FutureBuilder<ChartData>(
                        key: _refreshKey,
                        future: _model.getEconomicData(forceRefresh: _refreshKey != UniqueKey()),
                        builder: (context, snapshot) {
                          // Check if we have cached economic data to show immediately
                          ChartData? economicData;
                          
                          if (_model.hasValidEconomicCache) {
                            // Use cached data immediately
                            economicData = _model.cachedEconomicData;
                          } else if (snapshot.hasData) {
                            // Use fresh data if no cache
                            economicData = snapshot.data!;
                          } else if (snapshot.connectionState == ConnectionState.waiting) {
                            // Show loading only if no cache available
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

                          if (economicData == null) {
                            return _buildDefaultIndicators();
                          }

                          return Row(
                            children: [
                              Expanded(
                                child: _buildEconomicCard(
                                  'GDP (USD \$)',
                                  WorldBankApiService.formatLargeNumber(
                                      economicData.latestGDP),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: _buildEconomicCard(
                                  'FDI (USD \$)',
                                  WorldBankApiService.formatLargeNumber(
                                      economicData.latestFDI),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: _buildEconomicCard(
                                  'Inflation Rate',
                                  WorldBankApiService.formatPercentage(
                                      economicData!.latestInflation),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 20.0),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 12.0),
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
                            width: MediaQuery.of(context).size.width -
                                32.0, // Full width minus padding
                            height:
                                200.0, // Increased height for better visibility
                            child: FutureBuilder<ChartData>(
                              key: _refreshKey,
                              future: _model.getChartData(forceRefresh: _refreshKey != UniqueKey()),
                              builder: (context, snapshot) {
                                // Check if we have cached data to show immediately
                                ChartData? chartData;
                                
                                if (_model.hasValidChartCache) {
                                  // Use cached data immediately
                                  chartData = _model.cachedChartData;
                                } else if (snapshot.hasData) {
                                  // Use fresh data if no cache
                                  chartData = snapshot.data!;
                                } else if (snapshot.connectionState == ConnectionState.waiting) {
                                  // Show loading only if no cache available
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF39EF8C),
                                    ),
                                  );
                                }

                                if (chartData == null) {
                                  return Center(
                                    child: Text(
                                      'Failed to load chart data',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }
                                
                                // Get chart data (either cached or fresh)
                                final gdpSpots = chartData.gdpSpots;
                                final fdiSpots = chartData.fdiSpots;
                                final rawGdpValues = chartData.rawGdpValues;
                                final rawFdiValues = chartData.rawFdiValues;
                                
                                // Log cache status
                                debugPrint('Using ${_model.hasValidChartCache ? "cached" : "fresh"} chart data');
                                
                                // Start animations only after data is loaded
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (_gdpLineController.status == AnimationStatus.dismissed) {
                                    _startAnimations();
                                  }
                                });
                                
                                // If we have no data, show a message
                                if (gdpSpots.isEmpty || fdiSpots.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'No chart data available',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }

                                return AnimatedBuilder(
                                  animation: Listenable.merge([_gdpLineAnimation, _fdiLineAnimation]),
                                  builder: (context, child) {
                                    // Create animated spots for progressive line drawing
                                    List<FlSpot> animatedGdpSpots = [];
                                    List<FlSpot> animatedFdiSpots = [];
                                    
                                    // Calculate how many points to show based on animation progress
                                    int gdpPointsToShow = (_gdpLineAnimation.value * gdpSpots.length).round();
                                    int fdiPointsToShow = (_fdiLineAnimation.value * fdiSpots.length).round();
                                    
                                    // Add points progressively for GDP
                                    for (int i = 0; i < gdpPointsToShow && i < gdpSpots.length; i++) {
                                      animatedGdpSpots.add(gdpSpots[i]);
                                    }
                                    
                                    // Add partial point for smooth animation
                                    if (gdpPointsToShow < gdpSpots.length && _gdpLineAnimation.value > 0) {
                                      double progress = (_gdpLineAnimation.value * gdpSpots.length) - gdpPointsToShow;
                                      if (gdpPointsToShow > 0 && gdpPointsToShow < gdpSpots.length) {
                                        FlSpot currentSpot = gdpSpots[gdpPointsToShow - 1];
                                        FlSpot nextSpot = gdpSpots[gdpPointsToShow];
                                        double interpolatedX = currentSpot.x + (nextSpot.x - currentSpot.x) * progress;
                                        double interpolatedY = currentSpot.y + (nextSpot.y - currentSpot.y) * progress;
                                        animatedGdpSpots.add(FlSpot(interpolatedX, interpolatedY));
                                      }
                                    }
                                    
                                    // Add points progressively for FDI
                                    for (int i = 0; i < fdiPointsToShow && i < fdiSpots.length; i++) {
                                      animatedFdiSpots.add(fdiSpots[i]);
                                    }
                                    
                                    // Add partial point for smooth animation
                                    if (fdiPointsToShow < fdiSpots.length && _fdiLineAnimation.value > 0) {
                                      double progress = (_fdiLineAnimation.value * fdiSpots.length) - fdiPointsToShow;
                                      if (fdiPointsToShow > 0 && fdiPointsToShow < fdiSpots.length) {
                                        FlSpot currentSpot = fdiSpots[fdiPointsToShow - 1];
                                        FlSpot nextSpot = fdiSpots[fdiPointsToShow];
                                        double interpolatedX = currentSpot.x + (nextSpot.x - currentSpot.x) * progress;
                                        double interpolatedY = currentSpot.y + (nextSpot.y - currentSpot.y) * progress;
                                        animatedFdiSpots.add(FlSpot(interpolatedX, interpolatedY));
                                      }
                                    }
                                    
                                    return LineChart(
                                      LineChartData(
                                        gridData: FlGridData(
                                          show: true,
                                          drawVerticalLine: true,
                                          drawHorizontalLine: true,
                                          horizontalInterval: 20,
                                          verticalInterval: 1,
                                          getDrawingHorizontalLine: (value) {
                                            return FlLine(
                                              color: Colors.grey
                                                  .withValues(alpha: 0.3),
                                              strokeWidth: 1.0,
                                            );
                                          },
                                          getDrawingVerticalLine: (value) {
                                            return FlLine(
                                              color: Colors.grey
                                                  .withValues(alpha: 0.3),
                                              strokeWidth: 1.0,
                                            );
                                          },
                                        ),
                                    titlesData: FlTitlesData(
                                      show: true,
                                      rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 30,
                                          getTitlesWidget: (value, meta) {
                                            const years = [
                                              '2020',
                                              '2021',
                                              '2022',
                                              '2023'
                                            ];
                                            if (value.toInt() >= 0 &&
                                                value.toInt() < years.length) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                  years[value.toInt()],
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              );
                                            }
                                            return Text('');
                                          },
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 50,
                                          interval: 25,
                                          getTitlesWidget: (value, meta) {
                                            // Show relative scale indicators
                                            if (value == 0)
                                              return Text('0%',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10));
                                            if (value == 50)
                                              return Text('50%',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10));
                                            if (value == 100)
                                              return Text('100%',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10));
                                            return Text('');
                                          },
                                        ),
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border(
                                        left: BorderSide(
                                            color: Colors.grey
                                                .withValues(alpha: 0.3),
                                            width: 1),
                                        bottom: BorderSide(
                                            color: Colors.grey
                                                .withValues(alpha: 0.3),
                                            width: 1),
                                      ),
                                    ),
                                    lineTouchData: LineTouchData(
                                      enabled: true,
                                      touchTooltipData: LineTouchTooltipData(
                                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                          return touchedSpots.map((LineBarSpot touchedSpot) {
                                            final spotIndex = touchedSpot.x.toInt();
                                            final years = ['2020', '2021', '2022', '2023'];
                                            
                                            if (spotIndex >= 0 && spotIndex < years.length) {
                                              final year = years[spotIndex];
                                              
                                              if (touchedSpot.barIndex == 0) {
                                                // GDP line
                                                final rawValue = rawGdpValues[spotIndex];
                                                if (rawValue != null) {
                                                  return LineTooltipItem(
                                                    'GDP $year\n${rawValue.toStringAsFixed(2)}T USD',
                                                    TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  );
                                                }
                                              } else if (touchedSpot.barIndex == 1) {
                                                // FDI line
                                                final rawValue = rawFdiValues[spotIndex];
                                                if (rawValue != null) {
                                                  return LineTooltipItem(
                                                    'FDI $year\n${rawValue.toStringAsFixed(2)}B USD',
                                                    TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  );
                                                }
                                              }
                                            }
                                            return null;
                                          }).toList();
                                        },
                                      ),
                                    ),
                                    minX: 0,
                                    maxX:
                                        3, // 4 data points (0-3) for 2020-2023 data
                                    minY: 0,
                                    maxY: 100, // Normalized scale
                                        lineBarsData: [
                                          // GDP Line (Green with enhanced styling and animation)
                                          if (animatedGdpSpots.isNotEmpty)
                                            LineChartBarData(
                                              spots: animatedGdpSpots,
                                              isCurved: true,
                                              curveSmoothness: 0.3,
                                              color: Color(0xFF39EF8C).withValues(
                                                alpha: _gdpLineAnimation.value,
                                              ),
                                              barWidth: 3,
                                              isStrokeCapRound: true,
                                              dotData: FlDotData(
                                                show: _gdpLineAnimation.value > 0.8,
                                                getDotPainter: (spot, percent, barData, index) {
                                                  return FlDotCirclePainter(
                                                    radius: 4,
                                                    color: Color(0xFF39EF8C),
                                                    strokeWidth: 2,
                                                    strokeColor: Colors.white,
                                                  );
                                                },
                                              ),
                                              belowBarData: BarAreaData(
                                                show: true,
                                                color: Color(0xFF39EF8C).withValues(
                                                  alpha: 0.1 * _gdpLineAnimation.value,
                                                ),
                                              ),
                                              shadow: Shadow(
                                                color: Color(0xFF39EF8C).withValues(
                                                  alpha: 0.3 * _gdpLineAnimation.value,
                                                ),
                                                offset: Offset(0, 2),
                                                blurRadius: 4,
                                              ),
                                            ),
                                          // FDI Line (Red with enhanced styling and animation)
                                          if (animatedFdiSpots.isNotEmpty)
                                            LineChartBarData(
                                              spots: animatedFdiSpots,
                                              isCurved: true,
                                              curveSmoothness: 0.3,
                                              color: Color(0xFFFF6B6B).withValues(
                                                alpha: _fdiLineAnimation.value,
                                              ),
                                              barWidth: 3,
                                              isStrokeCapRound: true,
                                              dotData: FlDotData(
                                                show: _fdiLineAnimation.value > 0.8,
                                                getDotPainter: (spot, percent, barData, index) {
                                                  return FlDotCirclePainter(
                                                    radius: 4,
                                                    color: Color(0xFFFF6B6B),
                                                    strokeWidth: 2,
                                                    strokeColor: Colors.white,
                                                  );
                                                },
                                              ),
                                              belowBarData: BarAreaData(
                                                show: true,
                                                color: Color(0xFFFF6B6B).withValues(
                                                  alpha: 0.1 * _fdiLineAnimation.value,
                                                ),
                                              ),
                                              shadow: Shadow(
                                                color: Color(0xFFFF6B6B).withValues(
                                                  alpha: 0.3 * _fdiLineAnimation.value,
                                                ),
                                                offset: Offset(0, 2),
                                                blurRadius: 4,
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          // Chart Legend
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 16,
                                          height: 3,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF39EF8C),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Africa GDP (Normalized)',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 10,
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
                                            color: Color(0xFFFF6B6B),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Africa FDI (Normalized)',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 10,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Values normalized to show relative trends',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Inter',
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ].divide(SizedBox(height: 5.0)),
                      ),
                    ),

                    // Economic Indicators with World Bank API

                    // Business Index and Natural Resources Row
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 0.0),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                              ),
                                          colors: [
                                            Color(0xFF5715AC),
                                            Color(0xFF47605D)
                                          ],
                                          gradientDirection:
                                              GradientDirection.ltr,
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
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Color(0xFFEF7D39),
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .override(
                                                      fontFamily:
                                                          'SF Pro Display',
                                                      useGoogleFonts: false,
                                                      color: Colors.white,
                                                      letterSpacing: 0.0,
                                                    ),
                                            elevation: 0.0,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                              ),
                                          colors: [
                                            Color(0xFF5715AC),
                                            Color(0xFF83B4AE)
                                          ],
                                          gradientDirection:
                                              GradientDirection.ltr,
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
                                            context
                                                .pushNamed('naturalResources');
                                          },
                                          text: 'Discover Resources',
                                          options: FFButtonOptions(
                                            height: 32.0,
                                            padding: EdgeInsets.all(8.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Color(0xFFEF7D39),
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .override(
                                                      fontFamily:
                                                          'SF Pro Display',
                                                      useGoogleFonts: false,
                                                      color: Colors.white,
                                                      letterSpacing: 0.0,
                                                    ),
                                            elevation: 0.0,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
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
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 0.0),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                              ),
                                          colors: [
                                            Color(0xFF5715AC),
                                            Color(0xFFA5BDBB)
                                          ],
                                          gradientDirection:
                                              GradientDirection.ltr,
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
                                            context
                                                .pushNamed('ProminentPeople');
                                          },
                                          text: 'See the top Players',
                                          options: FFButtonOptions(
                                            height: 32.0,
                                            padding: EdgeInsets.all(8.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Color(0xFFEF7D39),
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .override(
                                                      fontFamily:
                                                          'SF Pro Display',
                                                      useGoogleFonts: false,
                                                      color: Colors.white,
                                                      letterSpacing: 0.0,
                                                    ),
                                            elevation: 0.0,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                              ),
                                          colors: [
                                            Color(0xFF5715AC),
                                            Color(0xFFD4D4D4)
                                          ],
                                          gradientDirection:
                                              GradientDirection.ltr,
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
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Color(0xFFEF7D39),
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .override(
                                                      fontFamily:
                                                          'SF Pro Display',
                                                      useGoogleFonts: false,
                                                      color: Colors.white,
                                                      letterSpacing: 0.0,
                                                    ),
                                            elevation: 0.0,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
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
          child: _buildEconomicCard('FDI (USD \$)', '\$12.5B'),
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
