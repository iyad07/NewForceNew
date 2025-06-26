import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/supabase/database/tables/country_profiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'countries_list_model.dart';
export 'countries_list_model.dart';

class CountriesListWidget extends StatefulWidget {
  const CountriesListWidget({super.key});

  @override
  State<CountriesListWidget> createState() => _CountriesListWidgetState();
}

class _CountriesListWidgetState extends State<CountriesListWidget>
    with TickerProviderStateMixin {
  late CountriesListModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};



  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CountriesListModel());

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
    });

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF1E2022),
        appBar: _buildAppBar(),
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
              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  Expanded(
                    child: _buildCountriesList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
        onPressed: () => context.pop(),
      ),
      title: Text(
        'African Countries',
        style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'SFPro',
              color: Colors.white,
              fontSize: 20.0,
              letterSpacing: 0.0,
              useGoogleFonts: false,
            ),
      ),
      centerTitle: false,
      elevation: 2.0,
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore Africa',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'SFPro',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 24.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                  useGoogleFonts: false,
                ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Discover detailed profiles of all 54 African countries',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'SFPro',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountriesList() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 40.0),
      child: FutureBuilder<List<CountryProfilesRow>>(
        future: CountryProfilesTable().queryRows(
          queryFn: (q) => q.order('country', ascending: true).limit(100),
        ),
        builder: (context, snapshot) {
          // Show loading indicator while data is being fetched
          if (!snapshot.hasData) {
            return Container(
              height: 100,
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

          List<CountryProfilesRow> listViewCountryProfilesRowList = snapshot.data!;

          // If no data, hide the section completely instead of showing fallback image
          if (listViewCountryProfilesRowList.isEmpty) {
            return const SizedBox.shrink();
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: listViewCountryProfilesRowList.length,
            itemBuilder: (context, listViewIndex) {
              final listViewCountryProfilesRow = listViewCountryProfilesRowList[listViewIndex];
              
              // Debug: Print flag URL to console
              if (kDebugMode) {
                print('Country: ${listViewCountryProfilesRow.country}, Flag URL: ${listViewCountryProfilesRow.flagImageUrl}');
              }
              return InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed(
                    'countryProfile',
                    queryParameters: {
                      'countrydetails': serializeParam(
                        listViewCountryProfilesRow,
                        ParamType.SupabaseRow,
                      ),
                    }.withoutNulls,
                    extra: <String, dynamic>{
                      kTransitionInfoKey: const TransitionInfo(
                        hasTransition: true,
                        transitionType: PageTransitionType.fade,
                        duration: Duration(milliseconds: 600),
                      ),
                    },
                  );
                },
                child: Container(
                  width: 100.0,
                  height: 62.0,
                  decoration: const BoxDecoration(),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 18.0, 0.0),
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: listViewCountryProfilesRow.flagImageUrl?.isNotEmpty == true
                              ? CachedNetworkImage(
                                  imageUrl: listViewCountryProfilesRow.flagImageUrl!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
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
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.flag,
                                      color: Colors.grey[600],
                                      size: 25,
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.flag,
                                    color: Colors.grey[600],
                                    size: 25,
                                  ),
                                ),
                        ),
                      ),
                      Text(
                        valueOrDefault<String>(
                          listViewCountryProfilesRow.country,
                          'Unknown Country',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Tiro Bangla',
                          fontSize: 15.0,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!);
            },
          );
        },
      ),
    );
  }
}