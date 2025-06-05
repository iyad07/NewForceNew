import 'package:cached_network_image/cached_network_image.dart';
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

  void _initializeData() {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    
    if (newsProvider.africanNews.isNotEmpty) {
      newsProvider.reCategorizeExistingArticles();
    }
    
    Future.microtask(() async {
      try {
        await newsProvider.fetchAfricanNews(forceRefresh: false);
      } catch (e) {
        debugPrint('Background news fetch failed: $e');
      }
    });
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: _buildAppBar(),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCountryHeader(),
                  _buildNewsSection(countryName),
                  _buildActionButtons(),
                ].addToEnd(const SizedBox(height: 44.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Country Profile',
        style: FlutterFlowTheme.of(context).headlineMedium.override(
          fontFamily: 'SFPro',
          color: FlutterFlowTheme.of(context).primaryText,
          fontSize: 20.0,
          letterSpacing: 0.0,
          useGoogleFonts: false,
        ),
      ),
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
          _buildCountryStats(),
          _buildCountryInfo(),
        ].divide(const SizedBox(width: 8.0)),
      ),
    );
  }

  Widget _buildCountryStats() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          valueOrDefault<String>(widget.countrydetails?.country, 'Unknown'),
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
            Text(
              '\$',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Tiro Bangla',
                fontSize: 20.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6.0),
            Text(
              valueOrDefault<String>(widget.countrydetails?.countryGDP, '0'),
              style: FlutterFlowTheme.of(context).displaySmall.override(
                fontFamily: 'SFPro',
                fontSize: 20.0,
                letterSpacing: 0.0,
                useGoogleFonts: false,
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
            RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: valueOrDefault<String>(widget.countrydetails?.gdpRate, '0'),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Tiro Bangla',
                      color: FlutterFlowTheme.of(context).primary,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ' from 2023'),
                ],
                style: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'SFPro',
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCountryInfo() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: CachedNetworkImage(
            imageUrl: widget.countrydetails?.flagImageUrl ?? '',
            width: 40.0,
            height: 40.0,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Icon(Icons.flag, color: Colors.grey[600]),
            ),
          ),
        ),
        const SizedBox(height: 5.0),
        _buildInfoRow('Population:', widget.countrydetails?.population ?? '0'),
        _buildInfoRow('Currency:', widget.countrydetails?.currency ?? '0'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.max,
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
        Text(
          value,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Tiro Bangla',
            fontSize: 12.0,
            letterSpacing: 0.0,
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
    return Consumer<NewsProvider>(
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
    return Consumer<NewsProvider>(
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

  Widget _buildEmptyState(String countryName, NewsProvider newsProvider) {
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
            child: const Text('Refresh News', style: TextStyle(color: Colors.white)),
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
    final imageUrl = article.getField<String>('article_image') ?? '';
    
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: 160.0,
          height: 136.0,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 160.0,
            height: 136.0,
            color: Colors.grey[300],
            child: Icon(Icons.image, color: Colors.grey[600], size: 50),
          ),
          errorWidget: (context, url, error) => Container(
            width: 160.0,
            height: 136.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, color: Colors.grey[600], size: 40),
                Text(
                  'No Image',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
      child: Row(
        children: [
          _buildActionButton(
            icon: Icons.trending_up_rounded,
            label: 'Top Stocks',
            onTap: () => context.pushNamed(
              'topStocksPage',
              queryParameters: {
                'country': serializeParam(widget.countrydetails?.country, ParamType.String),
              }.withoutNulls,
            ),
          ),
          _buildActionButton(
            icon: Icons.groups_3_sharp,
            label: 'Top Profiles',
            onTap: () => context.pushNamed(
              'countryInfluencialFigures',
              queryParameters: {
                'country': serializeParam(widget.countrydetails?.country, ParamType.String),
              }.withoutNulls,
            ),
          ),
        ].divide(const SizedBox(width: 12.0)),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 64.0,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 3.0,
                    color: Color(0x33000000),
                    offset: Offset(0.0, 1.0),
                  )
                ],
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 1.0,
                ),
              ),
              child: Icon(icon, color: FlutterFlowTheme.of(context).primary, size: 32.0),
            ),
            const SizedBox(height: 12.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Tiro Bangla',
                letterSpacing: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToArticleDetails(dynamic article) {
    context.pushNamed(
      'newForceArticleDetails',
      queryParameters: {
        'publisher': serializeParam(article.publishers, ParamType.String),
        'articleImage': serializeParam(
          article.getField<String>('article_image') ?? '',
          ParamType.String,
        ),
        'description': serializeParam(article.description, ParamType.String),
        'newsbody': serializeParam(
          article.getField<String>('article_body') ??
              article.description ??
              'No content available',
          ParamType.String,
        ),
        'title': serializeParam(article.title, ParamType.String),
        'datecreated': serializeParam(article.createdAt, ParamType.DateTime),
        'newsUrl': serializeParam(
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
}