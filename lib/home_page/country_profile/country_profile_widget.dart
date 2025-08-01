import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '/backend/supabase/supabase.dart';
import '/backend/scrapers/news_provider.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'country_profile_model.dart';
export 'country_profile_model.dart';

class CountryProfileWidget extends StatefulWidget {
  const CountryProfileWidget({
    super.key,
    required this.countrydetails,
  });

  final CountryProfilesRow? countrydetails;

  @override
  State<CountryProfileWidget> createState() => _CountryProfileWidgetState();
}

class _CountryProfileWidgetState extends State<CountryProfileWidget>
    with TickerProviderStateMixin {
  late CountryProfileModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};
  TheCountryProfileRow? _countryProfileData;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CountryProfileModel());

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

    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
  }

  void _initializeData() async {
    final newsProvider = Provider.of<EnhancedNewsProvider>(context, listen: false);

    await newsProvider.initializeFromLocalStorage();

    if (newsProvider.africanNews.isNotEmpty) {
      newsProvider.reCategorizeExistingArticles();
    }

    unawaited(newsProvider.fetchAllNews());
    
    // Test Supabase connection first
    await _testSupabaseConnection();
    
    // Fetch country profile data from theCountryProfile table
    await _fetchCountryProfileData();
  }

  Future<void> _testSupabaseConnection() async {
    try {
      debugPrint('=== SUPABASE CONNECTION TEST ===');
      final testResponse = await SupaFlow.client
          .from('theCountryProfiles')
          .select('country')
          .limit(5);
      
      debugPrint('Table exists and returned ${testResponse.length} records');
      if (testResponse.isNotEmpty) {
        debugPrint('Sample countries: ${testResponse.map((r) => r['country']).toList()}');
      }
    } catch (e) {
      debugPrint('Supabase connection test failed: $e');
    }
    debugPrint('=== CONNECTION TEST END ===');
  }

  Future<void> _fetchCountryProfileData() async {
    try {
      final countryName = widget.countrydetails?.country ?? '';
      debugPrint('=== FETCH DEBUG ===');
      debugPrint('Attempting to fetch data for country: "$countryName"');
      
      if (countryName.isNotEmpty) {
        // Try exact match first
        var response = await SupaFlow.client
            .from('theCountryProfiles')
            .select()
            .eq('country', countryName)
            .maybeSingle();
        
        // If no exact match, try case-insensitive search
        if (response == null) {
          debugPrint('No exact match found, trying case-insensitive search...');
          final allRows = await SupaFlow.client
              .from('theCountryProfiles')
              .select();
          
          debugPrint('All available countries in table: ${allRows.map((row) => row['country']).toList()}');
          
          // Find case-insensitive match
          for (final row in allRows) {
            if (row['country']?.toString().toLowerCase() == countryName.toLowerCase()) {
              response = row;
              debugPrint('Found case-insensitive match: ${row['country']}');
              break;
            }
          }
        }
        
        debugPrint('Supabase response: $response');
        
        if (response != null) {
          debugPrint('Data found! Creating TheCountryProfileRow...');
          debugPrint('Response data: $response');
          setState(() {
            _countryProfileData = TheCountryProfileRow(response!);
            _isLoadingProfile = false;
          });
          debugPrint('Country profile data set successfully');
          debugPrint('GDP from new data: ${_countryProfileData?.gdp}');
        } else {
          debugPrint('No data found for country: $countryName');
          debugPrint('This could mean:');
          debugPrint('1. The table is empty');
          debugPrint('2. The country name does not match any records');
          debugPrint('3. There is a connection issue with Supabase');
          setState(() {
            _isLoadingProfile = false;
          });
        }
      } else {
        debugPrint('Country name is empty!');
        setState(() {
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching country profile data: $e');
      debugPrint('Error type: ${e.runtimeType}');
      setState(() {
        _isLoadingProfile = false;
      });
    }
    debugPrint('=== FETCH DEBUG END ===');
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countryName = widget.countrydetails?.country ?? '';

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
              padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
              child: RefreshIndicator(
                onRefresh: () => _refreshNews(),
                color: Color(0xFFFF8000),
                backgroundColor: Color(0xFF2A2D30),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCountryHeader(),
                      _buildCountryDetailsCards(),
                    ].addToEnd(const SizedBox(height: 44.0)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshNews() async {
    final newsProvider = Provider.of<EnhancedNewsProvider>(context, listen: false);
    await newsProvider.fetchAllNews(force: true);
  }

  Widget _buildCountryDetailsCards() {
    if (_isLoadingProfile) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(48.0),
          child: const SizedBox(
            width: 40.0,
            height: 40.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8000)),
              strokeWidth: 3.0,
            ),
          ),
        ),
      );
    }

    if (_countryProfileData == null) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2D30),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: const Color(0xFF3A3D41),
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                size: 64.0,
                color: Color(0xFF6C7075),
              ),
              const SizedBox(height: 16.0),
              Text(
                'No additional data available',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'SFPro',
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
              ),
              const SizedBox(height: 6.0),
              Text(
                'Country profile data is not available',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'SFPro',
                  color: const Color(0xFFB0B3B8),
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
          child: Text(
            'Country Details',
            style: FlutterFlowTheme.of(context).titleLarge.override(
              fontFamily: 'SFPro',
              fontSize: 20.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.normal,
              useGoogleFonts: false,
            ),
          ),
        ),
        _buildDetailCard('FDI Inflows', _countryProfileData!.fdiinflows?.toString() ?? 'N/A', Icons.trending_up),
        const SizedBox(height: 12.0),
        _buildDetailCard('Key Industries', _countryProfileData!.keyindustries ?? 'N/A', Icons.factory),
        const SizedBox(height: 12.0),
        _buildDetailCard('Ease of Business', _countryProfileData!.easeofbusiness?.toString() ?? 'N/A', Icons.business),
        const SizedBox(height: 12.0),
        _buildDetailCard('Corporate Tax', _countryProfileData!.corporatetaxpercentage != null ? '${_countryProfileData!.corporatetaxpercentage}%' : 'N/A', Icons.account_balance),
        const SizedBox(height: 12.0),
        _buildDetailCard('VAT Percentage', _countryProfileData!.vatpercentage != null ? '${_countryProfileData!.vatpercentage}%' : 'N/A', Icons.receipt),
        const SizedBox(height: 12.0),
        _buildDetailCard('Withholding Tax', _countryProfileData!.witholdingtaxpercentage != null ? '${_countryProfileData!.witholdingtaxpercentage}%' : 'N/A', Icons.money_off),
        const SizedBox(height: 12.0),
        _buildDetailCard('Political Stability Index', _countryProfileData!.politicalstabilityindex?.toString() ?? 'N/A', Icons.gavel),
      ],
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D30),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: const Color(0xFF3A3D41),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: const Color(0xFF3A3D41),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFF8000),
                size: 24.0,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'SFPro',
                      color: Colors.white,
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    value,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'SFPro',
                      color: const Color(0xFFB0B3B8),
                      fontSize: 14.0,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
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
        valueOrDefault<String>(widget.countrydetails?.country, 'Country Profile'),
        style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'SFPro',
              color: Colors.white,
              fontSize: 20.0,
              letterSpacing: 0.0,
              useGoogleFonts: false,
            ),
      ),
      actions: [
        Consumer<EnhancedNewsProvider>(
          builder: (context, newsProvider, child) {
            return IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: newsProvider.isLoading
                  ? null
                  : () => newsProvider.fetchAllNews(force: true),
            );
          },
        ),
      ],
      centerTitle: false,
      elevation: 2.0,
    );
  }

  Widget _buildCountryHeader() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 3,
            child: _buildCountryStats(),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            flex: 2,
            child: _buildCountryInfo(),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryStats() {
    // Use data from theCountryProfile table if available, otherwise fallback to old data
    final countryName = _countryProfileData?.country ?? widget.countrydetails?.country ?? 'Unknown';
    final gdp = _countryProfileData?.gdp ?? widget.countrydetails?.countryGDP ?? '0';
    final gdpRate = _countryProfileData?.rateofgdp ?? widget.countrydetails?.gdpRate ?? '0.0';
    
    // Debug print to check database values
    if (kDebugMode) {
      // Debug output for development
      if (kDebugMode) {
        print('=== COUNTRY PROFILE DEBUG ===');
        print('Country: $countryName');
        print('GDP: ${_formatGDP(gdp)}');
        print('GDP Rate: ${_formatGDPGrowthRate(gdpRate)} growth from 2023');
        //print('Using new data: ${widget.newData}');
        print('============================');
      }
    }
    
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          countryName,
          style: FlutterFlowTheme.of(context).labelMedium.override(
                fontFamily: 'SFPro',
                fontSize: 12.0,
                letterSpacing: 0.0,
                useGoogleFonts: false,
              ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                _formatGDP(gdp),
                style: FlutterFlowTheme.of(context).displaySmall.override(
                      fontFamily: 'SFPro',
                      fontSize: 20.0,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.trending_up_rounded,
              color: FlutterFlowTheme.of(context).primary,
              size: 20.0,
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: RichText(
                textScaler: MediaQuery.of(context).textScaler,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _formatGDPGrowthRate(gdpRate),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Tiro Bangla',
                            color: FlutterFlowTheme.of(context).primary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const TextSpan(text: ' growth from 2023'),
                  ],
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'SFPro',
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                ),
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCountryInfo() {
    // Use data from theCountryProfile table if available, otherwise fallback to old data
    final population = _countryProfileData?.population ?? widget.countrydetails?.population ?? '0';
    final currency = _countryProfileData?.currency ?? widget.countrydetails?.currency ?? 'N/A';
    
    // Debug population formatting in development mode
    if (kDebugMode) {
      print('Population: ${_formatPopulationWithLabel(population)}');
    }
    
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: _buildFlagImage(),
        ),
        const SizedBox(height: 5.0),
        _buildInfoRow('', _formatPopulationWithLabel(population)),
        _buildInfoRow('', currency),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Tiro Bangla',
                fontSize: 12.0,
                letterSpacing: 0.0,
              ),
        ),
        const SizedBox(width: 5.0),
        Expanded(
          child: Text(
            value,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Tiro Bangla',
                  fontSize: 12.0,
                  letterSpacing: 0.0,
                ),
            overflow: TextOverflow.visible,
            softWrap: true,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildNewsSection(String countryName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top News',
                style: FlutterFlowTheme.of(context).titleLarge.override(
                      fontFamily: 'SFPro',
                      fontSize: 20.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.normal,
                      useGoogleFonts: false,
                    ),
              ),
              _buildUpdateIndicator(),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height * 0.55,
          child: _buildNewsList(countryName),
        ),
      ],
    );
  }

  Widget _buildUpdateIndicator() {
    return Consumer<EnhancedNewsProvider>(
      builder: (context, newsProvider, child) {
        if (!newsProvider.isLoadingAfrican) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: FlutterFlowTheme.of(context).primary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Updating...',
                style: TextStyle(
                  fontSize: 12,
                  color: FlutterFlowTheme.of(context).primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNewsList(String countryName) {
    return Consumer<EnhancedNewsProvider>(
      builder: (context, newsProvider, child) {
        final countryNews = newsProvider.getNewsByCountry(countryName);

        if (countryNews.isEmpty && !newsProvider.isLoadingAfrican) {
          return _buildEmptyState(countryName, newsProvider);
        }

        if (countryNews.isEmpty && newsProvider.isLoadingAfrican) {
          return _buildLoadingState(countryName);
        }

        return RefreshIndicator(
          onRefresh: () => newsProvider.fetchAfricanNews(forceRefresh: true),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(0, 12.0, 0, 12.0),
            itemCount: countryNews.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8.0),
            itemBuilder: (context, index) => _buildNewsItem(countryNews[index]),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String countryName, EnhancedNewsProvider newsProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.newspaper, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No news available for $countryName',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => newsProvider.fetchAfricanNews(forceRefresh: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).primary,
            ),
            child: const Text('Refresh News',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(String countryName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: SpinKitRipple(
              color: FlutterFlowTheme.of(context).primary,
              size: 50.0,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading $countryName news...',
            style: FlutterFlowTheme.of(context).bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(dynamic article) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: InkWell(
        onTap: () => _navigateToArticleDetails(article),
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          width: 340.0,
          height: 216.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4.0,
                color: Color(0x2B202529),
                offset: Offset(0.0, 2.0),
              )
            ],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildArticleImage(article),
                      _buildArticleContent(article),
                    ],
                  ),
                ),
              ),
              _buildArticleFooter(article),
            ],
          ),
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
    );
  }

  Widget _buildArticleImage(dynamic article) {
    String imageUrl = _extractImageUrl(article);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: imageUrl.isNotEmpty &&
                imageUrl != "null" &&
                !imageUrl.toLowerCase().contains('null')
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                width: 160.0,
                height: 136.0,
                fit: BoxFit.cover,
                httpHeaders: const {
                  'User-Agent': 'Mozilla/5.0 (compatible; NewsApp/1.0)',
                },
                placeholder: (context, url) => Container(
                  width: 160.0,
                  height: 136.0,
                  color: Colors.grey[300],
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
                errorWidget: (context, url, error) => _buildImagePlaceholder(),
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 160.0,
      height: 136.0,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, color: Colors.grey[600], size: 40),
          Text(
            'No Image',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _extractImageUrl(dynamic article) {
    String imageUrl = '';

    try {
      if (article is Map<String, dynamic>) {
        imageUrl = article['articleImage'] ??
            article['article_image'] ??
            article['image'] ??
            article['imageUrl'] ??
            '';
      } else {
        imageUrl = article.getField<String>('articleImage') ?? '';

        if (imageUrl.isEmpty) {
          imageUrl = article.getField<String>('article_image') ?? '';
        }

        if (imageUrl.isEmpty) {
          imageUrl = article.getField<String>('image') ?? '';
        }

        if (imageUrl.isEmpty) {
          try {
            imageUrl = article.articleImage ?? '';
          } catch (e) {
            debugPrint('No articleImage property: $e');
          }
        }
      }

      if (imageUrl.isEmpty || imageUrl == 'null' || imageUrl == 'NULL') {
        imageUrl = '';
      }
    } catch (e) {
      debugPrint('Error accessing image URL: $e');
      imageUrl = '';
    }

    return imageUrl;
  }

  Widget _buildArticleContent(dynamic article) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 0.0, 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title ?? 'No Title',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'SFPro',
                    fontSize: 18.0,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5.0),
            AutoSizeText(
              article.description ?? 'No description available',
              maxLines: 3,
              style: FlutterFlowTheme.of(context).labelSmall.override(
                    fontFamily: 'SFPro',
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w300,
                    useGoogleFonts: false,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleFooter(dynamic article) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 8.0),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 20.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              dateTimeFormat("yMMMd", article.createdAt) ?? 'Recently',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'Tiro Bangla',
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }

void _navigateToArticleDetails(dynamic article) {
    final imageUrl = _extractImageUrl(article);
    
    // Get the article content - we know articleBody works from debug
    String articleContent = '';
    
    try {
      articleContent = article.getField<String>('articleBody') ?? '';
      
      if (articleContent.isEmpty) {
        articleContent = article.description ?? 'No content available';
      }
      
    } catch (e) {
      debugPrint('Error getting article content: $e');
      articleContent = article.description ?? 'No content available';
    }
    
    debugPrint('Navigating with content length: ${articleContent.length}');
    
    // Use the original route name from your code
    context.pushNamed(
      'newForceArticleDetails', // Changed back to original route name
      queryParameters: {
        'title': serializeParam(article.title, ParamType.String),
        'articleImage': serializeParam(imageUrl, ParamType.String),
        'description': serializeParam(article.description, ParamType.String),
        'country': serializeParam(
          article.getField<String>('country') ?? widget.countrydetails?.country ?? '',
          ParamType.String,
        ),
        'newsbody': serializeParam(articleContent, ParamType.String), // Keep original param name
        'publisher': serializeParam(article.publishers, ParamType.String),
        'datecreated': serializeParam(article.createdAt, ParamType.DateTime), // Keep original param name
        'newsUrl': serializeParam( // Keep original param name
          article.getField<String>('articleUrl') ?? 
          article.getField<String>('article_url') ?? '',
          ParamType.String,
        ),
      }.withoutNulls,
      extra: <String, dynamic>{
        kTransitionInfoKey: const TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.fade,
        ),
      },
    );  
  }

  // Helper method to format GDP values with currency symbol and units
  String _formatGDP(String value) {
    if (value.isEmpty || value == '0') return '\$0';
    
    // Check if value already contains units (Billion, Million, etc.)
    if (value.toLowerCase().contains('billion') || 
        value.toLowerCase().contains('million') || 
        value.toLowerCase().contains('trillion')) {
      // If it already has units, just add currency symbol if missing
      if (value.startsWith('\$')) {
        return value;
      } else {
        return '\$' + value.toLowerCase();
      }
    }
    
    // Remove any existing formatting for numeric processing
    String cleanValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
    
    try {
      double numValue = double.parse(cleanValue);
      
      // Format based on magnitude with currency symbol
      if (numValue >= 1000000000000) {
        return '\$${(numValue / 1000000000000).toStringAsFixed(1)} trillion';
      } else if (numValue >= 1000000000) {
        return '\$${(numValue / 1000000000).toStringAsFixed(1)} billion';
      } else if (numValue >= 1000000) {
        return '\$${(numValue / 1000000).toStringAsFixed(1)} million';
      } else if (numValue >= 1000) {
        return '\$${(numValue / 1000).toStringAsFixed(1)}K';
      } else {
        return '\$${numValue.toStringAsFixed(0)}';
      }
    } catch (e) {
      return '\$' + value; // Return original with currency symbol if parsing fails
    }
  }

  // Helper method to format GDP growth rate
  String _formatGDPGrowthRate(String value) {
    if (value.isEmpty || value == '0') return '0%';
    
    // Remove any existing formatting except decimal points
    String cleanValue = value.replaceAll(RegExp(r'[^0-9.-]'), '');
    
    try {
      double numValue = double.parse(cleanValue);
      return '${numValue.toStringAsFixed(1)}%';
    } catch (e) {
      return value.contains('%') ? value : value + '%';
    }
  }

  // Helper method to format currency values (keeping original for other uses)
  String _formatCurrency(String value) {
    if (value.isEmpty || value == '0') return '0';
    
    // Remove any existing formatting
    String cleanValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
    
    try {
      double numValue = double.parse(cleanValue);
      
      // Format based on magnitude
      if (numValue >= 1000000000000) {
        return '${(numValue / 1000000000000).toStringAsFixed(1)} Trillion';
      } else if (numValue >= 1000000000) {
        return '${(numValue / 1000000000).toStringAsFixed(1)} Billion';
      } else if (numValue >= 1000000) {
        return '${(numValue / 1000000).toStringAsFixed(1)} Million';
      } else if (numValue >= 1000) {
        return '${(numValue / 1000).toStringAsFixed(1)}K';
      } else {
        return numValue.toStringAsFixed(0);
      }
    } catch (e) {
      return value; // Return original if parsing fails
    }
  }

  // Helper method to format population values with label
  String _formatPopulationWithLabel(String value) {
    if (value.isEmpty || value == '0') return 'Population: 0';
    
    // Check if value already contains units or text
    if (value.toLowerCase().contains('million') || 
        value.toLowerCase().contains('billion') || 
        value.toLowerCase().contains('thousand') ||
        value.toLowerCase().contains('population')) {
      // If it already has formatting, ensure it starts with "Population:"
      if (value.toLowerCase().startsWith('population:')) {
        return value;
      } else {
        return value.toLowerCase();
      }
    }
    
    // Remove any existing formatting for numeric processing
    String cleanValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
    
    try {
      double numValue = double.parse(cleanValue);
      
      // Format based on magnitude with Population label
      if (numValue >= 1000000000) {
        return 'Population: ${(numValue / 1000000000).toStringAsFixed(1)} billion';
      } else if (numValue >= 1000000) {
        return 'Population: ${(numValue / 1000000).toStringAsFixed(1)} million';
      } else if (numValue >= 1000) {
        return 'Population: ${(numValue / 1000).toStringAsFixed(1)}K';
      } else {
        return 'Population: ${numValue.toStringAsFixed(0)}';
      }
    } catch (e) {
      return 'Population: ' + value; // Return original with label if parsing fails
    }
  }

  // Helper method to format population values (keeping original for other uses)
  String _formatPopulation(String value) {
    if (value.isEmpty || value == '0') return '0';
    
    // Remove any existing formatting
    String cleanValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
    
    try {
      double numValue = double.parse(cleanValue);
      
      // Format based on magnitude
      if (numValue >= 1000000000) {
        return '${(numValue / 1000000000).toStringAsFixed(1)} Billion';
      } else if (numValue >= 1000000) {
        return '${(numValue / 1000000).toStringAsFixed(1)} Million';
      } else if (numValue >= 1000) {
        return '${(numValue / 1000).toStringAsFixed(1)}K';
      } else {
        return numValue.toStringAsFixed(0);
      }
    } catch (e) {
      return value; // Return original if parsing fails
    }
  }

  Widget _buildFlagImage() {
    // Use flag image from theCountryProfile table if available, otherwise fallback to old data
    final flagUrl = _countryProfileData?.flagimage ?? widget.countrydetails?.flagImageUrl;
    
    // Check if URL is valid and not empty
    if (flagUrl == null || flagUrl.isEmpty || !_isValidImageUrl(flagUrl)) {
      return _buildFallbackFlag();
    }
    
    return CachedNetworkImage(
      imageUrl: flagUrl,
      width: 40.0,
      height: 40.0,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: const CircularProgressIndicator(strokeWidth: 2.0),
      ),
      errorWidget: (context, url, error) {
        if (kDebugMode) {
          print('Flag image error for URL: $url - Error: $error');
        }
        return _buildFallbackFlag();
      },
    );
  }

  bool _isValidImageUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && 
             (uri.scheme == 'http' || uri.scheme == 'https') &&
             uri.host.isNotEmpty &&
             (url.toLowerCase().contains('.png') || 
              url.toLowerCase().contains('.jpg') || 
              url.toLowerCase().contains('.jpeg') || 
              url.toLowerCase().contains('.gif') || 
              url.toLowerCase().contains('.webp') ||
              url.toLowerCase().contains('.svg'));
    } catch (e) {
      return false;
    }
  }

  Widget _buildFallbackFlag() {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Icon(
        Icons.flag_outlined,
        color: FlutterFlowTheme.of(context).secondaryText,
        size: 20.0,
      ),
    );
  }
}
