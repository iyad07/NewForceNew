import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'country_news_details_model.dart';
export 'country_news_details_model.dart';

class CountryNewsDetailsWidget extends StatefulWidget {
  const CountryNewsDetailsWidget({
    super.key,
    required this.title,
    required this.articleImage,
    required this.description,
    required this.country,
    required this.newsbody,
    this.publisher,
    this.publishedDate,
    this.articleUrl,
  });

  final String? title;
  final String? articleImage;
  final String? description;
  final String? country;
  final String? newsbody;
  final String? publisher;
  final DateTime? publishedDate;
  final String? articleUrl;

  @override
  State<CountryNewsDetailsWidget> createState() =>
      _CountryNewsDetailsWidgetState();
}

class _CountryNewsDetailsWidgetState extends State<CountryNewsDetailsWidget> {
  late CountryNewsDetailsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CountryNewsDetailsModel());
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroImage(),
                  _buildArticleContent(),
                  _buildActionButtons(),
                ].divide(const SizedBox(height: 16.0)),
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
        buttonSize: 50.0,
        icon: Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 20.0,
        ),
        onPressed: () => context.safePop(),
      ),
      title: Text(
        'Article Details',
        style: FlutterFlowTheme.of(context).bodyLarge.override(
          fontFamily: 'Tiro Bangla',
          color: Colors.white,
          letterSpacing: 0.0,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.share,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          onPressed: _shareArticle,
        ),
        if (widget.articleUrl?.isNotEmpty == true)
          IconButton(
            icon: Icon(
              Icons.open_in_browser,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
            onPressed: _openOriginalArticle,
          ),
      ],
      centerTitle: false,
      elevation: 2.0,
    );
  }

  Widget _buildHeroImage() {
    final imageUrl = widget.articleImage;
    
    return SizedBox(
      height: 240.0,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(0.0),
            child: imageUrl?.isNotEmpty == true && 
                   imageUrl != "null" && 
                   !imageUrl!.toLowerCase().contains('null')
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    width: double.infinity,
                    height: 240.0,
                    fit: BoxFit.cover,
                    httpHeaders: const {
                      'User-Agent': 'Mozilla/5.0 (compatible; NewsApp/1.0)',
                    },
                    placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: 240.0,
                      color: Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => _buildImagePlaceholder(),
                  )
                : _buildImagePlaceholder(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 240.0,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, color: Colors.grey[600], size: 60),
          const SizedBox(height: 8),
          Text(
            'No Image Available',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleContent() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildArticleHeader(),
          const SizedBox(height: 16),
          _buildArticleBody(),
        ],
      ),
    );
  }

  Widget _buildArticleHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          valueOrDefault<String>(widget.title, 'No Title'),
          style: FlutterFlowTheme.of(context).headlineMedium.override(
            fontFamily: 'SFPro',
            fontSize: 24.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.bold,
            useGoogleFonts: false,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          valueOrDefault<String>(widget.description, 'No description available'),
          style: FlutterFlowTheme.of(context).bodyLarge.override(
            fontFamily: 'SFPro',
            fontSize: 16.0,
            letterSpacing: 0.0,
            color: FlutterFlowTheme.of(context).secondaryText,
            useGoogleFonts: false,
          ),
        ),
        const SizedBox(height: 12),
        _buildMetaInfo(),
      ],
    );
  }

  Widget _buildMetaInfo() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (widget.country?.isNotEmpty == true)
          _buildMetaChip(
            icon: Icons.location_on,
            label: widget.country!,
            color: FlutterFlowTheme.of(context).primary,
          ),
        if (widget.publisher?.isNotEmpty == true)
          _buildMetaChip(
            icon: Icons.newspaper,
            label: widget.publisher!,
            color: FlutterFlowTheme.of(context).secondary,
          ),
        if (widget.publishedDate != null)
          _buildMetaChip(
            icon: Icons.access_time,
            label: dateTimeFormat("MMM d, yyyy", widget.publishedDate!),
            color: FlutterFlowTheme.of(context).tertiary,
          ),
      ],
    );
  }

  Widget _buildMetaChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleBody() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Article Content',
            style: FlutterFlowTheme.of(context).titleMedium.override(
              fontFamily: 'SFPro',
              fontSize: 18.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
              useGoogleFonts: false,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            valueOrDefault<String>(widget.newsbody, 'No content available'),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'SFPro',
              fontSize: 14.0,
              letterSpacing: 0.0,
              //height: 1.6,
              useGoogleFonts: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions',
            style: FlutterFlowTheme.of(context).titleMedium.override(
              fontFamily: 'SFPro',
              fontSize: 18.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
              useGoogleFonts: false,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.share,
                  label: 'Share Article',
                  onTap: _shareArticle,
                  color: FlutterFlowTheme.of(context).primary,
                ),
              ),
              if (widget.articleUrl?.isNotEmpty == true) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.open_in_browser,
                    label: 'Read Original',
                    onTap: _openOriginalArticle,
                    color: FlutterFlowTheme.of(context).secondary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareArticle() {
    final title = widget.title ?? 'News Article';
    final description = widget.description ?? 'Check out this news article';
    final url = widget.articleUrl ?? '';
    
    String shareText = '$title\n\n$description';
    if (url.isNotEmpty) {
      shareText += '\n\nRead more: $url';
    }
    
    Share.share(shareText, subject: title);
  }

  void _openOriginalArticle() async {
    final url = widget.articleUrl;
    if (url?.isNotEmpty == true) {
      try {
        final uri = Uri.parse(url!);
        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        } else {
          _showErrorSnackBar('Could not open the article URL');
        }
      } catch (e) {
        debugPrint('Error launching URL: $e');
        _showErrorSnackBar('Invalid article URL');
      }
    } else {
      _showErrorSnackBar('No original article URL available');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: FlutterFlowTheme.of(context).error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}