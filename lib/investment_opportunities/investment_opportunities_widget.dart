import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'investment_opportunities_model.dart';
export 'investment_opportunities_model.dart';

class InvestmentOpportunitiesWidget extends StatefulWidget {
  const InvestmentOpportunitiesWidget({super.key, this.initialSector});

  final String? initialSector;

  @override
  State<InvestmentOpportunitiesWidget> createState() =>
      _InvestmentOpportunitiesWidgetState();
}

class _InvestmentOpportunitiesWidgetState
    extends State<InvestmentOpportunitiesWidget> {
  late InvestmentOpportunitiesModel _model;
  String? selectedSector;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InvestmentOpportunitiesModel());
    
    // Map topic names to sector names
    selectedSector = _mapTopicToSector(widget.initialSector);
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
        if (mounted && _model.unfocusNode.canRequestFocus) {
          FocusScope.of(context).requestFocus(_model.unfocusNode);
        } else if (mounted) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
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
            'Investment Opportunities',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'SF Pro Display',
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: _buildOpportunitiesList(selectedSector),
        ),
      ),
    );
  }

  Widget _buildOpportunitiesList(String? sector) {
    return FutureBuilder<List<InvestmentOpportunitiesRow>>(
      future: InvestmentOpportunitiesTable().queryRows(
        queryFn: (q) => sector != null
            ? q.eq('sector', sector).order('sector').order('title')
            : q.order('sector').order('title'),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading opportunities',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
          );
        }

        final opportunities = snapshot.data ?? [];

        if (opportunities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.business_center,
                  size: 64.0,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
                const SizedBox(height: 16.0),
                Text(
                  sector == null
                      ? 'No investment opportunities available'
                      : 'No opportunities in $sector sector',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'SF Pro Display',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                ),
              ],
            ),
          );
        }

        // Group opportunities by sector if showing all
        if (sector == null) {
          final groupedOpportunities = <String, List<InvestmentOpportunitiesRow>>{};
          for (final opportunity in opportunities) {
            final sectorName = opportunity.sector ?? 'Other';
            groupedOpportunities.putIfAbsent(sectorName, () => []).add(opportunity);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: groupedOpportunities.keys.length,
            itemBuilder: (context, index) {
              final sectorName = groupedOpportunities.keys.elementAt(index);
              final sectorOpportunities = groupedOpportunities[sectorName]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, top: 16.0),
                    child: Text(
                      sectorName,
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontFamily: 'SF Pro Display',
                            color: FlutterFlowTheme.of(context).primary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: false,
                          ),
                    ),
                  ),
                  ...sectorOpportunities.map((opportunity) => _buildOpportunityCard(opportunity)),
                ],
              );
            },
          );
        }

        // Show opportunities for specific sector
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: opportunities.length,
          itemBuilder: (context, index) {
            return _buildOpportunityCard(opportunities[index]);
          },
        );
      },
    );
  }

  Widget _buildOpportunityCard(InvestmentOpportunitiesRow opportunity) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: const Color(0x1A000000),
            offset: const Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    opportunity.title ?? 'Untitled Opportunity',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'SF Pro Display',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: false,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: _getSectorColor(opportunity.sector).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: _getSectorColor(opportunity.sector),
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    opportunity.sector ?? 'Other',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'SF Pro Display',
                          color: _getSectorColor(opportunity.sector),
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
            Text(
              opportunity.description ?? 'No description available',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'SF Pro Display',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (opportunity.website?.isNotEmpty == true) ...[
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: FFButtonWidget(
                  onPressed: () async {
                    try {
                      final url = opportunity.website!;
                      print('Attempting to launch URL: $url');
                      
                      final uri = Uri.parse(url);
                      
                      if (await canLaunchUrl(uri)) {
                        print('URL can be launched, opening...');
                        final launched = await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                        if (launched) {
                          print('URL launched successfully');
                        } else {
                          print('Failed to launch URL');
                        }
                      } else {
                        print('Cannot launch URL: $url');
                        // Fallback: try with platform default mode
                        await launchUrl(uri, mode: LaunchMode.platformDefault);
                      }
                    } catch (e) {
                      print('Error launching URL: $e');
                      // Show user-friendly error message
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Unable to open link. Please try again.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  },
                  text: 'Learn More',
                  icon: const Icon(
                    Icons.open_in_new,
                    size: 16.0,
                  ),
                  options: FFButtonOptions(
                    height: 36.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'SF Pro Display',
                          color: Colors.white,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                    elevation: 2.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String? _mapTopicToSector(String? topicName) {
    if (topicName == null) {
      print('DEBUG: No topic name provided');
      return null;
    }
    
    print('DEBUG: Topic name received: "$topicName"');
    
    String? mappedSector;
    switch (topicName.toLowerCase()) {
      case 'trade':
      case 'trading':
      case 'business':
        mappedSector = 'Trade';

        break;
      case 'real estate':
      case 'property':
      case 'housing':
        mappedSector = 'Real Estate';
        break;
      case 'energy':
      case 'oil':
      case 'gas':
      case 'renewable':
        mappedSector = 'Energy';
        break;
      case 'technology':
      case 'tech':
      case 'digital':
        mappedSector = 'Technology';
        break;
      case 'agriculture':
      case 'farming':
      case 'agri':
        mappedSector = 'Agriculture';
        break;
      default:
        mappedSector = null; // Show all opportunities if no match
    }
    
    print('DEBUG: Mapped to sector: "$mappedSector"');
    return mappedSector;
  }

  Color _getSectorColor(String? sector) {
    switch (sector?.toLowerCase()) {
      case 'technology':
        return const Color(0xFF4285F4);
      case 'agriculture':
        return const Color(0xFF34A853);
      case 'energy':
        return const Color(0xFFFF9800);
      case 'finance':
        return const Color(0xFF9C27B0);
      case 'real estate':
        return const Color(0xFF795548);
      default:
        return FlutterFlowTheme.of(context).primary;
    }
  }
}