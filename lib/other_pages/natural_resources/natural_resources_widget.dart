// natural_resources_widget.dart - Fixed syntax errors
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'dart:async';
import '/backend/supabase/database/tables/africa_resources.dart';
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

  // Carousel controllers
  late PageController _mineralsPageController;
  late PageController _cashCropsPageController;
  Timer? _mineralsTimer;
  Timer? _cashCropsTimer;

  // No longer need state for expanded country details since we're using popup

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NaturalResourcesModel());

    // Initialize carousel controllers
    _mineralsPageController = PageController(
      viewportFraction: 0.4, // Shows wider cards with less gap
    );
    _cashCropsPageController = PageController(
      viewportFraction: 0.4, // Shows wider cards with less gap
    );

    // Fetch data from Supabase
    _fetchData();

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
    _mineralsTimer?.cancel();
    _cashCropsTimer?.cancel();
    _mineralsPageController.dispose();
    _cashCropsPageController.dispose();

    super.dispose();
  }

  // Fetch data from Supabase
  Future<void> _fetchData() async {
    await _model.fetchAfricaResourcesData();
    if (mounted) {
      setState(() {});
    }
  }

  void _startAutoSlide() {
    // Auto-slide for minerals
    _mineralsTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && _mineralsPageController.hasClients && mineralsData.isNotEmpty) {
        int currentPage = _mineralsPageController.page?.round() ?? 0;
        int nextPage = (currentPage + 1) % mineralsData.length;
        _mineralsPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    // Auto-slide for cash crops (with slight delay to avoid synchronization)
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _cashCropsTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
          if (mounted && _cashCropsPageController.hasClients && cashCropsData.isNotEmpty) {
            int currentPage = _cashCropsPageController.page?.round() ?? 0;
            int nextPage = (currentPage + 1) % cashCropsData.length;
            _cashCropsPageController.animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

// Enhanced _buildResourceCard method with onTap functionality
Widget _buildResourceCard(Map<String, dynamic> resourceData) {
  return _buildGlassmorphicContainer(
    color: resourceData['color'],
    child: Container(
      height: 200.0,
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resource Header
          Row(
            children: [
              Text(
                resourceData['icon'],
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(width: 6.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resourceData['name'],
                      style: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .override(
                            fontFamily: 'SF Pro Display',
                            useGoogleFonts: false,
                            color: Colors.white,
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 1.0),
                    Text(
                      'Top 5 Producers',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'SF Pro Display',
                            useGoogleFonts: false,
                            color: Colors.white70,
                            fontSize: 9.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Show countries list
          Expanded(
            child: _buildCountriesList(resourceData),
          ),
        ],
      ),
    ),
  );
}

// Build scrollable countries list
Widget _buildCountriesList(Map<String, dynamic> resourceData) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: resourceData['countries']
          .take(5)
          .map<Widget>((country) => _buildCountryCard(country, resourceData))
          .toList(),
    ),
  );
}

// Build individual country card with onTap
Widget _buildCountryCard(Map<String, dynamic> country, Map<String, dynamic> resourceData) {
  return GestureDetector(
    onTap: () {
      _showCountryDetailsPopup(country, resourceData);
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white.withOpacity(0.12),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Flag and country name column
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Country flag
              Text(
                country['flag'],
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 4.0),
              // Country name
              Text(
                country['country'],
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'SF Pro Display',
                      useGoogleFonts: false,
                      color: Colors.white,
                      fontSize: 9.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          
          const Spacer(),
          
          // Export value
          Text(
            country['exportValue'],
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'SF Pro Display',
                  useGoogleFonts: false,
                  color: const Color(0xFF00FF0A),
                  fontSize: 10.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    ),
  );
}

  // Show country details in a glassmorphic popup
  void _showCountryDetailsPopup(Map<String, dynamic> country, Map<String, dynamic> resourceData) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 600,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      resourceData['color'].withOpacity(0.2),
                      resourceData['color'].withOpacity(0.1),
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with close button
                      Row(
                        children: [
                          Text(
                            country['flag'],
                            style: const TextStyle(fontSize: 32.0),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  country['country'],
                                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                                        fontFamily: 'SF Pro Display',
                                        useGoogleFonts: false,
                                        color: Colors.white,
                                        fontSize: 24.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  '${resourceData['name']} Production Details',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'SF Pro Display',
                                        useGoogleFonts: false,
                                        color: Colors.white70,
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),

                      // Detailed information cards
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildDetailCard(
                                'Global Rank',
                                country['globalRank'],
                                Icons.public,
                                const Color(0xFF00FF0A),
                              ),
                              const SizedBox(height: 12.0),

                              _buildDetailCard(
                                'Export Value',
                                country['exportValue'],
                                Icons.trending_up,
                                const Color(0xFF00FF0A),
                              ),
                              const SizedBox(height: 12.0),

                              _buildDetailCard(
                                'National Export %',
                                country['nationalExport'] ?? 'N/A',
                                Icons.pie_chart,
                                Colors.orange,
                              ),
                              const SizedBox(height: 12.0),

                              _buildDetailCard(
                                'Major Destinations',
                                country['destinations'] ?? 'N/A',
                                Icons.location_on,
                                Colors.blue,
                              ),
                              const SizedBox(height: 12.0),

                              _buildDetailCard(
                                'Year',
                                country['year'],
                                Icons.calendar_today,
                                Colors.purple,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

// Build individual detail card
Widget _buildDetailCard(String title, String value, IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      color: Colors.white.withOpacity(0.1),
      border: Border.all(
        color: color.withOpacity(0.3),
        width: 1.0,
      ),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: color.withOpacity(0.2),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20.0,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'SF Pro Display',
                      useGoogleFonts: false,
                      color: Colors.white70,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                    ),
              ),
              const SizedBox(height: 4.0),
              Text(
                value,
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'SF Pro Display',
                      useGoogleFonts: false,
                      color: Colors.white,
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
Widget _buildGlassmorphicContainer({
    required Widget child,
    required Color color,
  }) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: Color(0x5257636C),
            width: 1.0,
          ),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: child,
                ))));
  }

  // Sample data for minerals with glassmorphic styling
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
          'flag': '🇧🇫',
          'exportValue': '\$3.5B',
          'globalRank': '#4 Global',
          'nationalExport': '78%',
          'destinations': 'Switzerland, UAE',
          'year': '2025'
        },
        {
          'country': 'Mali',
          'flag': '🇲🇱',
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
          'flag': '🇿🇼',
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
  
  @override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () => _model.unfocusNode.canRequestFocus
        ? FocusScope.of(context).requestFocus(_model.unfocusNode)
        : FocusScope.of(context).unfocus(),
    child: Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF222426),
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
            'Natural Resources',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'SF Pro Display',
                  useGoogleFonts: false,
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
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
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF222426), Color(0xFF121416)],
              stops: [0.0, 1.0],
              begin: AlignmentDirectional(1.0, -0.34),
              end: AlignmentDirectional(-1.0, 0.34),
            ),
          ),
          child: Column(
            children: [
              // Content - Sectioned Layout
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Minerals Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'MINERALS',
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    fontFamily: 'SF Pro Display',
                                    useGoogleFonts: false,
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 24.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      // Minerals Carousel
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 320.0, // Increased height for better content accommodation
                          child: PageView.builder(
                            controller: _mineralsPageController,
                            itemCount: mineralsData.length,
                            itemBuilder: (context, index) {
                              return Container(
                                key: ValueKey('mineral_${index}_${mineralsData[index]['name']}'),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4.0),
                                child: _buildResourceCard(mineralsData[index]),
                              );
                            },
                          ),
                        ),
                      ),

                      // Cash Crops Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'CASH CROPS',
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    fontFamily: 'SF Pro Display',
                                    useGoogleFonts: false,
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 24.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      // Cash Crops Carousel
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 320.0, // Increased height for better content accommodation
                          child: PageView.builder(
                            controller: _cashCropsPageController,
                            itemCount: cashCropsData.length,
                            itemBuilder: (context, index) {
                              return Container(
                                key: ValueKey('cashcrop_${index}_${cashCropsData[index]['name']}'),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4.0),
                                child: _buildResourceCard(cashCropsData[index]),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 40.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
  
  }