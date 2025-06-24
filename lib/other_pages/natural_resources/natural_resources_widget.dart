import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:ui';
import 'dart:async';
import 'natural_resources_model.dart';
export 'natural_resources_model.dart';

class NaturalResourcesWidget extends StatefulWidget {
  const NaturalResourcesWidget({super.key});

  @override
  State<NaturalResourcesWidget> createState() => _NaturalResourcesWidgetState();
}

class _NaturalResourcesWidgetState extends State<NaturalResourcesWidget>
    with TickerProviderStateMixin {
  late NaturalResourcesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NaturalResourcesModel());
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
    );
    
    // Initialize PageView controllers with viewportFraction for partial visibility
    _model.pageViewController = PageController(
      viewportFraction: 0.85, // Shows part of next/previous cards
    );
    _model.cashCropsPageViewController = PageController(
      viewportFraction: 0.85, // Shows part of next/previous cards
    );
    
    // Start auto-slide timers
    _startAutoSlide();

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
            begin: const Offset(0.0, 50.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }
  
  void _startAutoSlide() {
    // Auto-slide for minerals tab
    _model.mineralsAutoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_model.pageViewController != null && _model.pageViewController!.hasClients) {
        final currentPage = _model.pageViewCurrentIndex;
        final nextPage = (currentPage + 1) % mineralsData.length;
        _model.pageViewController!.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
    
    // Auto-slide for cash crops tab
    _model.cashCropsAutoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_model.cashCropsPageViewController != null && _model.cashCropsPageViewController!.hasClients) {
        final currentPage = _model.cashCropsCurrentIndex;
        final nextPage = (currentPage + 1) % cashCropsData.length;
        _model.cashCropsPageViewController!.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Sample data for minerals
  final List<Map<String, dynamic>> mineralsData = [
    {
      'name': 'Gold',
      'icon': '🏆',
      'color': const Color(0xFFFFD700),
      'countries': [
        {
          'country': 'Ghana',
          'flag': '🇬🇭',
          'exportValue': '\$6.6B',
          'globalRank': '#6 Global',
          'nationalExport': '38%',
          'destinations': 'China, UAE, India',
          'year': '2025'
        },
        {
          'country': 'South Africa',
          'flag': '🇿🇦',
          'exportValue': '\$15.1B',
          'globalRank': '#1 Global',
          'nationalExport': '15%',
          'destinations': 'UK, UAE, USA',
          'year': '2025'
        },
        {
          'country': 'Burkina Faso',
          'flag': '��',
          'exportValue': '\$3.5B',
          'globalRank': '#4 Global',
          'nationalExport': '78%',
          'destinations': 'Switzerland, UAE',
          'year': '2025'
        },
        {
          'country': 'Mali',
          'flag': '��',
          'exportValue': '\$3.5B',
          'globalRank': '#7 Global',
          'nationalExport': '64%',
          'destinations': 'UAE, Switzerland',
          'year': '2025'
        },
        {
          'country': 'Tanzania',
          'flag': '🇹🇿',
          'exportValue': '\$2.1B',
          'globalRank': '#9 Global',
          'nationalExport': '32%',
          'destinations': 'India, UAE',
          'year': '2025'
        }
      ]
    },
    {
      'name': 'Silver',
      'icon': '🥈',
      'color': const Color(0xFFC0C0C0),
      'countries': [
        {
          'country': 'Morocco',
          'flag': '🇲🇦',
          'exportValue': '\$1.2B',
          'globalRank': '#12 Global',
          'nationalExport': '3%',
          'destinations': 'Spain, France',
          'year': '2025'
        },
        {
          'country': 'South Africa',
          'flag': '🇿🇦',
          'exportValue': '\$890M',
          'globalRank': '#15 Global',
          'nationalExport': '1%',
          'destinations': 'UK, Germany',
          'year': '2025'
        },
        {
          'country': 'Egypt',
          'flag': '🇪🇬',
          'exportValue': '\$234M',
          'globalRank': '#23 Global',
          'nationalExport': '0.8%',
          'destinations': 'Italy, UAE',
          'year': '2025'
        },
        {
          'country': 'Ghana',
          'flag': '🇬🇭',
          'exportValue': '\$156M',
          'globalRank': '#28 Global',
          'nationalExport': '1.2%',
          'destinations': 'UAE, India',
          'year': '2025'
        },
        {
          'country': 'Zimbabwe',
          'flag': '🇼',
          'exportValue': '\$89M',
          'globalRank': '#35 Global',
          'nationalExport': '2.1%',
          'destinations': 'South Africa',
          'year': '2025'
        }
      ]
    },
    {
      'name': 'Diamond',
      'icon': '💎',
      'color': const Color(0xFF87CEEB),
      'countries': [
        {
          'country': 'Botswana',
          'flag': '🇧🇼',
          'exportValue': '\$4.2B',
          'globalRank': '#1 Global',
          'nationalExport': '85%',
          'destinations': 'Belgium, India',
          'year': '2025'
        },
        {
          'country': 'Angola',
          'flag': '🇦🇴',
          'exportValue': '\$1.5B',
          'globalRank': '#5 Global',
          'nationalExport': '4%',
          'destinations': 'UAE, Belgium',
          'year': '2025'
        },
        {
          'country': 'South Africa',
          'flag': '🇿🇦',
          'exportValue': '\$1.2B',
          'globalRank': '#7 Global',
          'nationalExport': '1.2%',
          'destinations': 'Belgium, UAE',
          'year': '2025'
        },
        {
          'country': 'DR Congo',
          'flag': '🇨🇩',
          'exportValue': '\$489M',
          'globalRank': '#12 Global',
          'nationalExport': '4.8%',
          'destinations': 'Belgium, UAE',
          'year': '2025'
        },
        {
          'country': 'Zimbabwe',
          'flag': '🇿🇼',
          'exportValue': '\$262M',
          'globalRank': '#18 Global',
          'nationalExport': '6.2%',
          'destinations': 'Belgium, UAE',
          'year': '2025'
        }
      ]
    },
    {
      'name': 'Bauxite',
      'icon': '🪨',
      'color': const Color(0xFFCD853F),
      'countries': [
        {
          'country': 'Guinea',
          'flag': '🇬🇳',
          'exportValue': '\$3.4B',
          'globalRank': '#1 Global',
          'nationalExport': '95%',
          'destinations': 'China, UAE',
          'year': '2025'
        },
        {
          'country': 'Ghana',
          'flag': '🇬🇭',
          'exportValue': '\$566M',
          'globalRank': '#6 Global',
          'nationalExport': '3.2%',
          'destinations': 'China, India',
          'year': '2025'
        },
        {
          'country': 'Sierra Leone',
          'flag': '🇸🇱',
          'exportValue': '\$234M',
          'globalRank': '#12 Global',
          'nationalExport': '34%',
          'destinations': 'China, UAE',
          'year': '2025'
        },
        {
          'country': 'Mozambique',
          'flag': '🇲🇿',
          'exportValue': '\$156M',
          'globalRank': '#18 Global',
          'nationalExport': '3.1%',
          'destinations': 'China, India',
          'year': '2025'
        },
        {
          'country': 'Egypt',
          'flag': '🇪🇬',
          'exportValue': '\$89M',
          'globalRank': '#22 Global',
          'nationalExport': '0.3%',
          'destinations': 'Turkey, Italy',
          'year': '2025'
        }
      ]
    },
    {
      'name': 'Crude Oil',
      'icon': '🛢️',
      'color': const Color(0xFF2F4F4F),
      'countries': [
        {
          'country': 'Nigeria',
          'flag': '🇳🇬',
          'exportValue': '\$45.2B',
          'globalRank': '#8 Global',
          'nationalExport': '85%',
          'destinations': 'India, USA, Spain',
          'year': '2025'
        },
        {
          'country': 'Angola',
          'flag': '🇦🇴',
          'exportValue': '\$32.1B',
          'globalRank': '#12 Global',
          'nationalExport': '92%',
          'destinations': 'China, India, USA',
          'year': '2025'
        },
        {
          'country': 'Algeria',
          'flag': '🇩🇿',
          'exportValue': '\$28.5B',
          'globalRank': '#15 Global',
          'nationalExport': '78%',
          'destinations': 'Italy, Spain, France',
          'year': '2025'
        },
        {
          'country': 'Libya',
          'flag': '🇱🇾',
          'exportValue': '\$18.7B',
          'globalRank': '#18 Global',
          'nationalExport': '95%',
          'destinations': 'Italy, Germany, Spain',
          'year': '2025'
        },
        {
          'country': 'Egypt',
          'flag': '🇪🇬',
          'exportValue': '\$12.3B',
          'globalRank': '#22 Global',
          'nationalExport': '45%',
          'destinations': 'Italy, India, Jordan',
          'year': '2025'
        }
      ]
    },
    {
      'name': 'Natural Gas',
      'icon': '🔥',
      'color': const Color(0xFF4169E1),
      'countries': [
        {
          'country': 'Algeria',
          'flag': '🇩🇿',
          'exportValue': '\$15.8B',
          'globalRank': '#7 Global',
          'nationalExport': '42%',
          'destinations': 'Italy, Spain, Turkey',
          'year': '2025'
        },
        {
          'country': 'Nigeria',
          'flag': '🇳🇬',
          'exportValue': '\$8.9B',
          'globalRank': '#14 Global',
          'nationalExport': '18%',
          'destinations': 'Spain, France, India',
          'year': '2025'
        },
        {
          'country': 'Egypt',
          'flag': '🇪🇬',
          'exportValue': '\$6.2B',
          'globalRank': '#18 Global',
          'nationalExport': '22%',
          'destinations': 'Jordan, Italy, Turkey',
          'year': '2025'
        },
        {
          'country': 'Libya',
          'flag': '🇱🇾',
          'exportValue': '\$4.1B',
          'globalRank': '#25 Global',
          'nationalExport': '12%',
          'destinations': 'Italy, Turkey, Spain',
          'year': '2025'
        },
        {
          'country': 'Mozambique',
          'flag': '🇲🇿',
          'exportValue': '\$2.8B',
          'globalRank': '#32 Global',
          'nationalExport': '65%',
          'destinations': 'India, Japan, China',
          'year': '2025'
        }
      ]
    },
    {
      'name': 'Cobalt',
      'icon': '⚡',
      'color': const Color(0xFF0047AB),
      'countries': [
        {
          'country': 'DR Congo',
          'flag': '🇨🇩',
          'exportValue': '\$2.8B',
          'globalRank': '#1 Global',
          'nationalExport': '28%',
          'destinations': 'China, Finland',
          'year': '2025'
        },
        {
          'country': 'Zambia',
          'flag': '🇿🇲',
          'exportValue': '\$345M',
          'globalRank': '#8 Global',
          'nationalExport': '4.2%',
          'destinations': 'China, UAE',
          'year': '2025'
        },
        {
          'country': 'Madagascar',
          'flag': '🇲🇬',
          'exportValue': '\$156M',
          'globalRank': '#12 Global',
          'nationalExport': '5.8%',
          'destinations': 'China, Japan',
          'year': '2025'
        },
        {
          'country': 'Morocco',
          'flag': '🇲🇦',
          'exportValue': '\$89M',
          'globalRank': '#18 Global',
          'nationalExport': '0.2%',
          'destinations': 'China, Belgium',
          'year': '2025'
        },
        {
          'country': 'South Africa',
          'flag': '🇿🇦',
          'exportValue': '\$67M',
          'globalRank': '#22 Global',
          'nationalExport': '0.1%',
          'destinations': 'China, Finland',
          'year': '2025'
        }
      ]
    }
  ];

  // Sample data for cash crops
  final List<Map<String, dynamic>> cashCropsData = [
    {
      'name': 'Cocoa',
      'icon': '🍫',
      'color': const Color(0xFF8B4513),
      'countries': [
        {
          'country': 'Ivory Coast',
          'flag': '🇨🇮',
          'exportValue': '\$3.2B',
          'globalRank': '#1 Global',
          'nationalExport': '23%',
          'destinations': 'Netherlands, USA',
          'year': '2025'
        },
        {
          'country': 'Ghana',
          'flag': '🇬🇭',
          'exportValue': '\$3.2B',
          'globalRank': '#2 Global',
          'nationalExport': '18%',
          'destinations': 'Netherlands, USA',
          'year': '2025'
        },
        {
          'country': 'Nigeria',
          'flag': '🇳🇬',
          'exportValue': '\$760M',
          'globalRank': '#4 Global',
          'nationalExport': '1.2%',
          'destinations': 'Netherlands, USA',
          'year': '2025'
        },
        {
          'country': 'Cameroon',
          'flag': '🇨🇲',
          'exportValue': '\$618M',
          'globalRank': '#5 Global',
          'nationalExport': '12%',
          'destinations': 'Netherlands, Italy',
          'year': '2025'
        },
        {
          'country': 'Uganda',
          'flag': '🇺🇬',
          'exportValue': '\$401M',
          'globalRank': '#8 Global',
          'nationalExport': '5.8%',
          'destinations': 'Belgium, Italy',
          'year': '2025'
        }
      ]
    },
    {
      'name': 'Coffee',
      'icon': '☕',
      'color': const Color(0xFF6F4E37),
      'countries': [
        {
          'country': 'Ethiopia',
          'flag': '🇪🇹',
          'exportValue': '\$1.8B',
          'globalRank': '#5 Global',
          'nationalExport': '31%',
          'destinations': 'Germany, Saudi Arabia',
          'year': '2025'
        },
        {
          'country': 'Uganda',
          'flag': '🇺🇬',
          'exportValue': '\$578M',
          'globalRank': '#8 Global',
          'nationalExport': '8.3%',
          'destinations': 'Sudan, Germany',
          'year': '2025'
        },
        {
          'country': 'Ivory Coast',
          'flag': '🇨🇮',
          'exportValue': '\$123M',
          'globalRank': '#23 Global',
          'nationalExport': '0.9%',
          'destinations': 'Algeria, Morocco',
          'year': '2025'
        },
        {
          'country': 'Kenya',
          'flag': '🇰🇪',
          'exportValue': '\$75M',
          'globalRank': '#27 Global',
          'nationalExport': '1.1%',
          'destinations': 'Belgium, USA',
          'year': '2025'
        },
        {
          'country': 'Tanzania',
          'flag': '🇹🇿',
          'exportValue': '\$57M',
          'globalRank': '#32 Global',
          'nationalExport': '0.9%',
          'destinations': 'Germany, Belgium',
          'year': '2025'
        }
      ]
    },
    {
      'name': 'Cotton',
      'icon': '🌾',
      'color': const Color(0xFFF5F5DC),
      'countries': [
        {
          'country': 'Benin',
          'flag': '🇧🇯',
          'exportValue': '\$565M',
          'globalRank': '#6 Global',
          'nationalExport': '32%',
          'destinations': 'Bangladesh, India',
          'year': '2025'
        },
        {
          'country': 'Burkina Faso',
          'flag': '🇧🇫',
          'exportValue': '\$478M',
          'globalRank': '#8 Global',
          'nationalExport': '11%',
          'destinations': 'Singapore, China',
          'year': '2025'
        },
        {
          'country': 'Mali',
          'flag': '🇲🇱',
          'exportValue': '\$435M',
          'globalRank': '#9 Global',
          'nationalExport': '8%',
          'destinations': 'China, Bangladesh',
          'year': '2025'
        },
        {
          'country': 'Ivory Coast',
          'flag': '🇨🇮',
          'exportValue': '\$262M',
          'globalRank': '#15 Global',
          'nationalExport': '1.9%',
          'destinations': 'Vietnam, Turkey',
          'year': '2025'
        },
        {
          'country': 'Tanzania',
          'flag': '🇹🇿',
          'exportValue': '\$100M',
          'globalRank': '#25 Global',
          'nationalExport': '1.5%',
          'destinations': 'India, Kenya',
          'year': '2025'
        }
      ]
    },
    {
      'name': 'Sugar Cane',
      'icon': '🌱',
      'color': const Color(0xFF90EE90),
      'countries': [
        {
          'country': 'Eswatini',
          'flag': '🇸🇿',
          'exportValue': '\$541M',
          'globalRank': '#8 Global',
          'nationalExport': '25%',
          'destinations': 'South Africa, EU',
          'year': '2025'
        },
        {
          'country': 'South Africa',
          'flag': '🇿🇦',
          'exportValue': '\$390M',
          'globalRank': '#12 Global',
          'nationalExport': '0.4%',
          'destinations': 'Mozambique, Botswana',
          'year': '2025'
        },
        {
          'country': 'Mauritius',
          'flag': '🇲🇺',
          'exportValue': '\$289M',
          'globalRank': '#18 Global',
          'nationalExport': '11%',
          'destinations': 'EU, USA',
          'year': '2025'
        },
        {
          'country': 'Zambia',
          'flag': '🇿🇲',
          'exportValue': '\$144M',
          'globalRank': '#28 Global',
          'nationalExport': '1.8%',
          'destinations': 'DR Congo, Tanzania',
          'year': '2025'
        },
        {
          'country': 'Malawi',
          'flag': '🇲🇼',
          'exportValue': '\$100M',
          'globalRank': '#35 Global',
          'nationalExport': '12%',
          'destinations': 'EU, UK',
          'year': '2025'
        }
      ]
    },
    {
      'name': 'Palm Oil',
      'icon': '🌴',
      'color': const Color(0xFFFF8C00),
      'countries': [
        {
          'country': 'Nigeria',
          'flag': '🇳🇬',
          'exportValue': '\$234M',
          'globalRank': '#15 Global',
          'nationalExport': '0.4%',
          'destinations': 'Ghana, Cameroon',
          'year': '2025'
        },
        {
          'country': 'Ghana',
          'flag': '🇬🇭',
          'exportValue': '\$156M',
          'globalRank': '#22 Global',
          'nationalExport': '0.9%',
          'destinations': 'Burkina Faso, Togo',
          'year': '2025'
        },
        {
          'country': 'Ivory Coast',
          'flag': '🇨🇮',
          'exportValue': '\$89M',
          'globalRank': '#28 Global',
          'nationalExport': '0.6%',
          'destinations': 'Mali, Burkina Faso',
          'year': '2025'
        },
        {
          'country': 'Cameroon',
          'flag': '🇨🇲',
          'exportValue': '\$67M',
          'globalRank': '#32 Global',
          'nationalExport': '1.3%',
          'destinations': 'Chad, CAR',
          'year': '2025'
        },
        {
          'country': 'Liberia',
          'flag': '🇱🇷',
          'exportValue': '\$45M',
          'globalRank': '#38 Global',
          'nationalExport': '15%',
          'destinations': 'EU, USA',
          'year': '2025'
        }
      ]
    }
  ];

  Widget _buildGlassmorphicContainer({
    required Widget child,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildResourceCard(Map<String, dynamic> resourceData) {
    return _buildGlassmorphicContainer(
      color: resourceData['color'],
      child: Container(
        width: 350.0,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: resourceData['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Text(
                      resourceData['icon'],
                      style: const TextStyle(fontSize: 24.0),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resourceData['name'],
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'SF Pro Display',
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: false,
                        ),
                      ),
                      Text(
                        'Top 5 African Exporters',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'SF Pro Display',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            // Countries List
            Expanded(
              child: ListView.builder(
                itemCount: resourceData['countries'].length,
                itemBuilder: (context, index) {
                  final country = resourceData['countries'][index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: resourceData['color'].withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Country Header
                        Row(
                          children: [
                            Text(
                              country['flag'],
                              style: const TextStyle(fontSize: 24.0),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                country['country'],
                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'SF Pro Display',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: false,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: resourceData['color'].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                country['year'],
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'SF Pro Display',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        // Stats Grid
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text('💰', style: TextStyle(fontSize: 16.0)),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        country['exportValue'],
                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                          fontFamily: 'SF Pro Display',
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          useGoogleFonts: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      const Text('🌍', style: TextStyle(fontSize: 16.0)),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        country['globalRank'],
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'SF Pro Display',
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text('�', style: TextStyle(fontSize: 16.0)),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        '${country['nationalExport']} of exports',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'SF Pro Display',
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      const Text('�', style: TextStyle(fontSize: 16.0)),
                                      const SizedBox(width: 4.0),
                                      Expanded(
                                        child: Text(
                                          country['destinations'],
                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: 'SF Pro Display',
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: false,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Natural Resources',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'SF Pro Display',
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 22.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.bold,
              useGoogleFonts: false,
            ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Africa\'s Natural Wealth',
                      style: FlutterFlowTheme.of(context).headlineLarge.override(
                        fontFamily: 'SF Pro Display',
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                        useGoogleFonts: false,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Explore the continent\'s rich mineral deposits and agricultural exports with detailed export data and market insights.',
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'SF Pro Display',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                    ),
                  ],
                ),
              ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
              
              // Tab Bar
              Container(
                width: double.infinity,
                height: 60.0,
                child: TabBar(
                  controller: _model.tabBarController,
                  labelColor: FlutterFlowTheme.of(context).primary,
                  unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
                  labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'SF Pro Display',
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    useGoogleFonts: false,
                  ),
                  unselectedLabelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'SF Pro Display',
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
                  indicatorColor: FlutterFlowTheme.of(context).primary,
                  indicatorWeight: 3.0,
                  tabs: const [
                    Tab(
                      text: 'Minerals',
                      icon: Icon(Icons.diamond),
                    ),
                    Tab(
                      text: 'Cash Crops',
                      icon: Icon(Icons.agriculture),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: TabBarView(
                  controller: _model.tabBarController,
                  children: [
                    // Minerals Tab
                    Container(
                      height: double.infinity,
                      child: PageView.builder(
                        controller: _model.pageViewController,
                        itemCount: mineralsData.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 20.0,
                            ),
                            child: _buildResourceCard(mineralsData[index]),
                          );
                        },
                      ),
                    ),
                    // Cash Crops Tab
                    Container(
                      height: double.infinity,
                      child: PageView.builder(
                        controller: _model.cashCropsPageViewController,
                        itemCount: cashCropsData.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 20.0,
                            ),
                            child: _buildResourceCard(cashCropsData[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              // Page Indicator
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Swipe to explore more resources',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'SF Pro Display',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Icon(
                      Icons.swipe,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 20.0,
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
}