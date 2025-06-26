import 'package:fl_chart/fl_chart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:new_force_new_hope/backend/supabase/database/database.dart';
import 'package:new_force_new_hope/backend/supabase/database/tables/country_profiles.dart';
import 'package:new_force_new_hope/backend/supabase/database/tables/investment_news.dart';
import 'package:new_force_new_hope/backend/supabase/supabase.dart';

import '/backend/api_requests/world_bank_api.dart';
import '/event_details/event_details_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'business_index_model.dart';
export 'business_index_model.dart';

class BusinessIndexWidget extends StatefulWidget {
  const BusinessIndexWidget({super.key});

  @override
  State<BusinessIndexWidget> createState() => _BusinessIndexWidgetState();
}

class _BusinessIndexWidgetState extends State<BusinessIndexWidget>
    with TickerProviderStateMixin {
  late BusinessIndexModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Tab state management - removed sectors, showing general continental data
  late TabController _regionalTabController;

  // Regional mapping for African countries
  final Map<String, String> _countryToRegion = {
    // Northern Africa
    'Egypt': 'Northern Africa',
    'Libya': 'Northern Africa',
    'Tunisia': 'Northern Africa',
    'Algeria': 'Northern Africa',
    'Morocco': 'Northern Africa',
    'Sudan': 'Northern Africa',
    
    // Southern Africa
    'South Africa': 'Southern Africa',
    'Botswana': 'Southern Africa',
    'Namibia': 'Southern Africa',
    'Zimbabwe': 'Southern Africa',
    'Zambia': 'Southern Africa',
    'Lesotho': 'Southern Africa',
    'Eswatini': 'Southern Africa',
    'Malawi': 'Southern Africa',
    'Mozambique': 'Southern Africa',
    
    // West Africa
    'Nigeria': 'West Africa',
    'Ghana': 'West Africa',
    'Senegal': 'West Africa',
    'Mali': 'West Africa',
    'Burkina Faso': 'West Africa',
    'Niger': 'West Africa',
    'Guinea': 'West Africa',
    'Sierra Leone': 'West Africa',
    'Liberia': 'West Africa',
    'Ivory Coast': 'West Africa',
    'Togo': 'West Africa',
    'Benin': 'West Africa',
    'Mauritania': 'West Africa',
    'Gambia': 'West Africa',
    'Guinea-Bissau': 'West Africa',
    'Cape Verde': 'West Africa',
    
    // Eastern Africa
    'Kenya': 'Eastern Africa',
    'Tanzania': 'Eastern Africa',
    'Uganda': 'Eastern Africa',
    'Rwanda': 'Eastern Africa',
    'Burundi': 'Eastern Africa',
    'Ethiopia': 'Eastern Africa',
    'Somalia': 'Eastern Africa',
    'Djibouti': 'Eastern Africa',
    'Eritrea': 'Eastern Africa',
    'Madagascar': 'Eastern Africa',
    'Mauritius': 'Eastern Africa',
    'Seychelles': 'Eastern Africa',
    'Comoros': 'Eastern Africa',
    
    // Central Africa
    'Congo':'Central Africa',
    'Cameroon': 'Central Africa',
    'Central African Republic': 'Central Africa',
    'Chad': 'Central Africa',
    'Democratic Republic of the Congo': 'Central Africa',
    'Republic of the Congo': 'Central Africa',
    'Equatorial Guinea': 'Central Africa',
    'Gabon': 'Central Africa',
    'São Tomé and Príncipe': 'Central Africa',
    'Angola': 'Central Africa',
  };

  final animationsMap = <String, AnimationInfo>{};
  late AnimationController _tabAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _tabSlideAnimation;
  late Animation<double> _cardScaleAnimation;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BusinessIndexModel());

    // Initialize regional tab controller
    _regionalTabController = TabController(length: 5, vsync: this);

    // Initialize custom animation controllers
    _tabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _tabSlideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _tabAnimationController,
      curve: Curves.easeInOut,
    ));

    _cardScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeInOut,
    ));

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 70.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'tabContainerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          SlideEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.0, -30.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'economicCardAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 500.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 500.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'economicCardAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 500.0.ms,
            duration: 500.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 500.0.ms,
            duration: 500.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'economicCardAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 500.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 500.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'chartContainerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 700.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 700.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 50.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'eventCardAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 800.0.ms,
            duration: 500.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          SlideEffect(
            curve: Curves.easeInOut,
            delay: 800.0.ms,
            duration: 500.0.ms,
            begin: const Offset(-30.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    // Start tab animation
    _tabAnimationController.forward();
  }

  @override
  void dispose() {
    _regionalTabController.dispose();
    _tabAnimationController.dispose();
    _cardAnimationController.dispose();
    _model.dispose();
    super.dispose();
  }

  Widget _buildInvestmentOpportunitiesSection() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(5.0, 20.0, 5.0, 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /* Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 8.0),
                                child: Text(
                                  'Invest in the Future of Africa',
                                  textAlign: TextAlign.left,
                                  style: FlutterFlowTheme.of(context).titleLarge.override(
                                    fontFamily: 'SFPro',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 22.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                                ),
                              ),*/
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 8.0),
            child: FutureBuilder<List<InvestmentNewsRow>>(
              future: InvestmentNewsTable().queryRows(
                queryFn: (q) => q
                    .not('name', 'ilike', '%politics%')
                    .not('name', 'ilike', '%stocks%')
                    .not('name', 'ilike', '%commodities%')
                    .order('name'),
              ),
              builder: (context, snapshot) {
                // Show loading indicator while data is being fetched
                if (!snapshot.hasData) {
                  return Container(
                    height: 80,
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  );
                }

                List<InvestmentNewsRow> rowInvestmentNewsRowList =
                    snapshot.data!;

                // If no data, hide the section completely instead of showing fallback image
                if (rowInvestmentNewsRowList.isEmpty) {
                  return const SizedBox.shrink();
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  //controller: _model.rowController5,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(rowInvestmentNewsRowList.length,
                            (rowIndex) {
                      final rowInvestmentNewsRow =
                          rowInvestmentNewsRowList[rowIndex];
                      return InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(
                            'InvestmentOpportunities',
                            queryParameters: {
                              'sector': rowInvestmentNewsRow.name ?? '',
                            },
                            extra: <String, dynamic>{
                              kTransitionInfoKey: const TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                                duration: Duration(milliseconds: 600),
                              ),
                            },
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 60.0,
                              height: 60.0,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: rowInvestmentNewsRow
                                          .topicImageUrl?.isNotEmpty ==
                                      true
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          rowInvestmentNewsRow.topicImageUrl!,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.business,
                                          color: Colors.grey[600],
                                          size: 30,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.business,
                                        color: Colors.grey[600],
                                        size: 30,
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                valueOrDefault<String>(
                                  rowInvestmentNewsRow.name,
                                  'Investment',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Tiro Bangla',
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                        .divide(const SizedBox(width: 8.0))
                        .around(const SizedBox(width: 8.0)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorldBankGDPChart(List<Map<String, dynamic>> gdpData) {
    // Transform World Bank GDP data into chart data
    List<BarChartGroupData> barGroups = [];
    List<String> years = [];

    if (gdpData.isEmpty) {
      // Fallback to default data if no World Bank data
      const defaultYears = [
        '2017',
        '2018',
        '2019',
        '2020',
        '2021',
        '2022',
        '2023',
        '2024'
      ];
      const defaultValues = [
        200.0,
        250.0,
        300.0,
        180.0,
        350.0,
        400.0,
        450.0,
        500.0
      ];

      years = defaultYears;
      for (int i = 0; i < defaultValues.length; i++) {
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                  toY: defaultValues[i],
                  color: FlutterFlowTheme.of(context).primary)
            ],
          ),
        );
      }
    } else {
      // Use World Bank API data
      // Sort data by year
      gdpData.sort((a, b) => (a['date'] ?? '').compareTo(b['date'] ?? ''));

      for (int i = 0; i < gdpData.length && i < 10; i++) {
        final data = gdpData[i];
        final year = data['date']?.toString() ?? '';
        final value = data['value'];

        if (year.isNotEmpty && value != null) {
          years.add(year);

          // Convert GDP value to billions for better chart visualization
          double gdpValue = (value is num) ? value.toDouble() : 0.0;
          gdpValue = gdpValue / 1000000000; // Convert to billions

          barGroups.add(
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                    toY: gdpValue, color: FlutterFlowTheme.of(context).primary)
              ],
            ),
          );
        }
      }
    }

    // Ensure we have at least some years for display
    if (years.isEmpty) {
      years = ['2017', '2018', '2019', '2020', '2021', '2022', '2023', '2024'];
    }

    // Calculate max Y value for better scaling
    double maxY = 500.0;
    if (barGroups.isNotEmpty) {
      final maxValue = barGroups
          .map((group) => group.barRods.first.toY)
          .reduce((a, b) => a > b ? a : b);
      maxY = (maxValue * 1.2).ceilToDouble(); // Add 20% padding
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GDP Trends (Billions USD)',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w600,
                useGoogleFonts: false,
              ),
        ),
        const SizedBox(height: 16.0),
        Expanded(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1500),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeInOutCubic,
            builder: (context, animationValue, child) {
              // Create animated bar groups
              final animatedBarGroups = barGroups.map((group) {
                return BarChartGroupData(
                  x: group.x,
                  barRods: group.barRods.map((rod) {
                    return BarChartRodData(
                      toY: rod.toY * animationValue,
                      color: rod.color,
                      width: rod.width,
                      borderRadius: BorderRadius.circular(4.0),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          rod.color!,
                          rod.color!.withOpacity(0.7),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }).toList();

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      //backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final year =
                            groupIndex < years.length ? years[groupIndex] : '';
                        final originalValue =
                            barGroups[groupIndex].barRods[rodIndex].toY;
                        return BarTooltipItem(
                          '\$${originalValue.toStringAsFixed(1)}B\n$year',
                          FlutterFlowTheme.of(context).bodySmall,
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < years.length) {
                            return AnimatedOpacity(
                              opacity: animationValue,
                              duration: const Duration(milliseconds: 500),
                              child: Text(
                                years[value.toInt()],
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'SF Pro Display',
                                      fontSize: 10.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        interval: maxY / 5, // Add proper interval to prevent overlapping
                        getTitlesWidget: (value, meta) {
                          // Only show labels at specific intervals to prevent overlapping
                          if (value % (maxY / 5) != 0 && value != 0) {
                            return const SizedBox.shrink();
                          }
                          return AnimatedOpacity(
                            opacity: animationValue,
                            duration: const Duration(milliseconds: 500),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '\$${value.toInt()}B',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'SF Pro Display',
                                      fontSize: 9.0,
                                      useGoogleFonts: false,
                                    ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          );
                        },
                      ),
                     ),
                     topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: animatedBarGroups,
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY / 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: FlutterFlowTheme.of(context)
                            .alternate
                            .withOpacity(0.3),
                        strokeWidth: 1,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        key: scaffoldKey,
        backgroundColor: Color(0xFF1E2022),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0x2C7E5F1A), Color(0xFF201D1B)],
                  stops: [0.0, 1.0],
                  begin: AlignmentDirectional(0.59, -1.0),
                  end: AlignmentDirectional(-0.59, 1.0),
                ),
              ),
            ),
            leading: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () async {
                context.pop();
              },
            ),
            title: Text(
              'Business Index',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'SF Pro Display',
                    color: Colors.white,
                    fontSize: 22.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    useGoogleFonts: false,
                  ),
            ),
            actions: const [],
            centerTitle: false,
            elevation: 0.0,
          ),
        ),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Continental Overview Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 16.0, 16.0, 16.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                ).animateOnPageLoad(animationsMap['tabContainerAnimation']!),

                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 0.0, 16.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Investment Opportunities Section
                      Text(
                        'Investment Opportunities',
                        style: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .override(
                              fontFamily: 'SF Pro Display',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 20.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: false,
                            ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Africa has Real Estate Investment Opportunities',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'SF Pro Display',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                      ),

                      // Investment Opportunities Content
                      _buildInvestmentOpportunitiesSection(),
                      // Continental Data and Investment Opportunities
                      const SizedBox(height: 24.0),

                      //const SizedBox(height: 32.0),
                      Text(
                        'GDP & Investment Inflows (2017-2024)',
                        style: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .override(
                              fontFamily: 'SF Pro Display',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: false,
                            ),
                      ),
                      const SizedBox(height: 16.0),

                      Container(
                        width: double.infinity,
                        height: 250.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: FlutterFlowTheme.of(context)
                                  .alternate
                                  .withOpacity(0.1),
                              blurRadius: 8.0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 16.0),
                          child: FutureBuilder<ApiCallResponse>(
                            future: WorldBankApiService.getGDPData(
                              countryCode: 'ZA',
                              startYear: '2015',
                              endYear: '2024',
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: SizedBox(
                                    width: 30.0,
                                    height: 30.0,
                                    child: SpinKitFadingCircle(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 30.0,
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.hasError || !snapshot.hasData) {
                                print(
                                    'Error fetching GDP chart data from World Bank API: ${snapshot.error}');
                                return Center(
                                  child: Text(
                                    'Chart data unavailable',
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                );
                              }

                              final response = snapshot.data!;
                              final gdpData = response.succeeded
                                  ? WorldBankApiService.parseWorldBankResponse(
                                      response.bodyText)
                                  : <Map<String, dynamic>>[];

                              print(
                                  'Fetched ${gdpData.length} GDP entries for chart from World Bank API');

                              return _buildWorldBankGDPChart(gdpData);
                            },
                          ),
                        ),
                      ).animateOnPageLoad(
                          animationsMap['chartContainerAnimation']!),

                      //_buildContinentalContent(),

                      // GDP & Investment Inflows Chart Section

                      // Upcoming Events Section
                      const SizedBox(height: 32.0),
                      Text(
                        'Upcoming Events',
                        style: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .override(
                              fontFamily: 'SF Pro Display',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: false,
                            ),
                      ),
                      const SizedBox(height: 16.0),

                      FutureBuilder<List<AfricanMarketRow>>(
                        future: AfricanMarketTable().queryRows(
                          queryFn: (q) =>
                              q.order('created_at', ascending: false).limit(3),
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: SizedBox(
                                width: 30.0,
                                height: 30.0,
                                child: SpinKitFadingCircle(
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 30.0,
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            print(
                                'Error fetching African market data: ${snapshot.error}');
                          }

                          List<AfricanMarketRow> marketData =
                              snapshot.data ?? [];
                          print(
                              'Fetched ${marketData.length} African market entries from Supabase');

                          // If no data, show default events
                          if (marketData.isEmpty) {
                            return Column(
                              children: [
                                _buildEventCard(
                                  'Investment Forum',
                                  'Ghana',
                                  'Agriculture',
                                  Colors.green,
                                ).animateOnPageLoad(
                                    animationsMap['eventCardAnimation']!),
                                const SizedBox(height: 12.0),
                                _buildEventCard(
                                  'Trade Expo',
                                  'South Africa',
                                  'Energy',
                                  FlutterFlowTheme.of(context).primary,
                                ).animateOnPageLoad(
                                    animationsMap['eventCardAnimation']!),
                                const SizedBox(height: 12.0),
                                _buildEventCard(
                                  'Energy Summit',
                                  'Kenya',
                                  'Website',
                                  FlutterFlowTheme.of(context).secondary,
                                ).animateOnPageLoad(
                                    animationsMap['eventCardAnimation']!),
                              ],
                            );
                          }

                          // Use market data to create event cards
                          return Column(
                            children: marketData.asMap().entries.map((entry) {
                              int index = entry.key;
                              AfricanMarketRow data = entry.value;

                              List<Color> colors = [
                                Colors.green,
                                FlutterFlowTheme.of(context).primary,
                                FlutterFlowTheme.of(context).secondary,
                              ];

                              List<String> categories = [
                                'Market Update',
                                'Investment',
                                'Business'
                              ];

                              return Column(
                                children: [
                                  if (index > 0) const SizedBox(height: 12.0),
                                  _buildEventCard(
                                    data.articleTitle ?? 'Market Event',
                                    data.articleDescription ?? 'Africa',
                                    categories[index % categories.length],
                                    colors[index % colors.length],
                                  ).animateOnPageLoad(
                                      animationsMap['eventCardAnimation']!),
                                ],
                              );
                            }).toList(),
                          );
                        },
                      ),

                      // Regional Top Stocks Section
                      const SizedBox(height: 32.0),
                      Text(
                        'Top Stocks by African Region',
                        style: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .override(
                              fontFamily: 'SF Pro Display',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: false,
                            ),
                      ),
                      const SizedBox(height: 16.0),
                      
                      _buildRegionalStocksTabs(),

                      const SizedBox(height: 32.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!));
  }

  Widget _buildContinentalContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // General Continental Overview
        Text(
          'Continental Business Insights',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'SF Pro Display',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 20.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
                useGoogleFonts: false,
              ),
        ),
        const SizedBox(height: 16.0),

        // General Continental Data Cards
        _buildWorldBankCard(
          'Economic Growth',
          'Africa shows resilient economic performance',
          'Diverse economies driving continental development',
          const Color(0xFF4CAF50),
        ),
        const SizedBox(height: 12.0),
        _buildWorldBankCard(
          'Trade Integration',
          'AfCFTA enhancing intra-African trade',
          'Continental free trade area boosting commerce',
          const Color(0xFF2196F3),
        ),
        const SizedBox(height: 12.0),
        _buildWorldBankCard(
          'Infrastructure Development',
          'Major investments in connectivity',
          'Transport, energy, and digital infrastructure expansion',
          const Color(0xFFFF9800),
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }

  Widget _buildEconomicCard(
      String title, String value, String subtitle, Color color) {
    return GestureDetector(
      onTap: () {
        // Add haptic feedback
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    title,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'SF Pro Display',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts: false,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, animationValue, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * animationValue),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'SF Pro Display',
                          color: color,
                          fontSize: 24.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: false,
                        ),
                  ),
                );
              },
            ),
            const SizedBox(height: 6.0),
            Text(
              subtitle,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'SF Pro Display',
                    color: color,
                    fontSize: 10.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                    useGoogleFonts: false,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultIndicators() {
    return Row(
      children: [
        Expanded(
          child: _buildEconomicCard(
            'GDP Growth',
            '4.1%',
            'View Details',
            FlutterFlowTheme.of(context).primary,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: _buildEconomicCard(
            'Inflation Rate',
            '12.5%',
            'View Details',
            FlutterFlowTheme.of(context).secondary,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: _buildEconomicCard(
            'FDI Inflows',
            '\$25.8B',
            'View Details',
            FlutterFlowTheme.of(context).tertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(
      String title, String location, String category, Color categoryColor) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _cardAnimationController.forward().then((_) {
          _cardAnimationController.reverse();
        });
        
        // Navigate to event details page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsWidget(
              eventTitle: title,
              eventLocation: location,
              eventCategory: category,
              eventDescription: '',
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
        decoration: BoxDecoration(
          color: Color(0xFF2A2D30),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Color(0xFF3A3D41),
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF8000),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    category,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'SF Pro Display',
                          color: Colors.white,
                          fontSize: 10.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: false,
                        ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFB0B3B8),
                  size: 16.0,
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              title,
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: 'SF Pro Display',
                    color: Colors.white,
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    useGoogleFonts: false,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6.0),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Color(0xFFB0B3B8),
                  size: 14.0,
                ),
                const SizedBox(width: 4.0),
                Text(
                  location,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'SF Pro Display',
                        color: Color(0xFFB0B3B8),
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestorCard(
      String name, String type, String focus, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
      decoration: BoxDecoration(
        color: Color(0xFF2A2D30),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Color(0xFF3A3D41),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Color(0xFF3A3D41),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              Icons.business,
              color: Color(0xFFFF8000),
              size: 24.0,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'SF Pro Display',
                        color: Colors.white,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        useGoogleFonts: false,
                      ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  type,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'SF Pro Display',
                        color: Color(0xFFB0B3B8),
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  focus,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'SF Pro Display',
                        color: Color(0xFFFF8000),
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        useGoogleFonts: false,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorldBankCard(
      String title, String subtitle, String description, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).alternate.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(
              Icons.trending_up,
              color: color,
              size: 24.0,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'SF Pro Display',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        useGoogleFonts: false,
                      ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'SF Pro Display',
                        color: color,
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        useGoogleFonts: false,
                      ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  description,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'SF Pro Display',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build regional stocks tabs
  Widget _buildRegionalStocksTabs() {
    return Container(
      height: 400,
      child: Column(
        children: [
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF2A2D30),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Color(0xFF3A3D41),
                width: 1.0,
              ),
            ),
            child: TabBar(
              controller: _regionalTabController,
              labelColor: Colors.white,
              unselectedLabelColor: Color(0xFFB0B3B8),
              indicatorColor: Color(0xFFFF8000),
              indicatorWeight: 3.0,
              labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'SF Pro Display',
                fontSize: 9.0,
                fontWeight: FontWeight.w600,
                useGoogleFonts: false,
              ),
              unselectedLabelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'SF Pro Display',
                fontSize: 9.0,
                fontWeight: FontWeight.w500,
                useGoogleFonts: false,
              ),
              tabs: [
                Tab(text: 'North\nAfrica'),
                Tab(text: 'South\nAfrica'),
                Tab(text: 'West\nAfrica'),
                Tab(text: 'East\nAfrica'),
                Tab(text: 'Central\nAfrica'),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _regionalTabController,
              children: [
                _buildRegionalStocksList('Northern Africa'),
                _buildRegionalStocksList('Southern Africa'),
                _buildRegionalStocksList('West Africa'),
                _buildRegionalStocksList('Eastern Africa'),
                _buildRegionalStocksList('Central Africa'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build stocks list for a specific region
  Widget _buildRegionalStocksList(String region) {
    return FutureBuilder<List<CountryTopStocksRow>>(
      future: CountryTopStocksTable().queryRows(
        queryFn: (q) => q.order('stockRate', ascending: false),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 30.0,
              height: 30.0,
              child: SpinKitFadingCircle(
                color: FlutterFlowTheme.of(context).primary,
                size: 30.0,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          print('Error fetching stocks data: ${snapshot.error}');
        }

        List<CountryTopStocksRow> allStocks = snapshot.data ?? [];
        
        // Filter stocks by region
        List<CountryTopStocksRow> regionalStocks = allStocks.where((stock) {
          String? country = stock.country;
          if (country == null) return false;
          return _countryToRegion[country] == region;
        }).toList();

        // If no regional data, show default message
        if (regionalStocks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.trending_up,
                  color: Color(0xFFB0B3B8),
                  size: 48.0,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'No stocks data available\nfor $region',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'SF Pro Display',
                    color: Color(0xFFB0B3B8),
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
                ),
              ],
            ),
          );
        }

        // Display regional stocks
        List<Color> colors = [
          FlutterFlowTheme.of(context).primary,
          FlutterFlowTheme.of(context).secondary,
          FlutterFlowTheme.of(context).tertiary,
          Color(0xFFFF8000),
        ];

        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: regionalStocks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12.0),
          itemBuilder: (context, index) {
            CountryTopStocksRow stock = regionalStocks[index];
            return _buildRegionalStockCard(
              stock.stockName ?? 'Unknown Stock',
              stock.country ?? 'Unknown Country',
              '${stock.stockRate ?? 0}%',
              colors[index % colors.length],
            );
          },
        );
      },
    );
  }

  // Build individual stock card for regional display
  Widget _buildRegionalStockCard(
      String stockName, String country, String rate, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
      decoration: BoxDecoration(
        color: Color(0xFF2A2D30),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Color(0xFF3A3D41),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              Icons.trending_up,
              color: color,
              size: 24.0,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stockName,
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'SF Pro Display',
                        color: Colors.white,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        useGoogleFonts: false,
                      ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  country,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'SF Pro Display',
                        color: Color(0xFFB0B3B8),
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 6.0),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              rate,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'SF Pro Display',
                    color: color,
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    useGoogleFonts: false,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
