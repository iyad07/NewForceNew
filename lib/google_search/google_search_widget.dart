import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'google_search_model.dart';
export 'google_search_model.dart';

class GoogleSearchWidget extends StatefulWidget {
  const GoogleSearchWidget({super.key});

  @override
  State<GoogleSearchWidget> createState() => _GoogleSearchWidgetState();
}

class _GoogleSearchWidgetState extends State<GoogleSearchWidget> {
  late GoogleSearchModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Replace with your actual Google Programmable Search Engine ID
  final String searchEngineId = '11b1adfa9c259416b';
  final String apiKey = 'AIzaSyA7dVLYFhA580CLL6h9LMkIiWWCR4zhf6U';
  
  String _currentSearchUrl = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GoogleSearchModel());
    
    // Initialize with Google Custom Search homepage
    _currentSearchUrl = 'https://cse.google.com/cse?cx=$searchEngineId';
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      setState(() {
        _currentSearchUrl = 'https://cse.google.com/cse?cx=$searchEngineId&q=${Uri.encodeComponent(query)}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.orange, // Orange theme
          automaticallyImplyLeading: false,
          title: Text(
            'Web Search',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'SFPro',
              color: Colors.white,
              fontSize: 22.0,
              letterSpacing: 0.0,
              useGoogleFonts: false,
            ),
          ),
          actions: [
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 50.0,
              icon: Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 24.0,
              ),
              onPressed: () {
                setState(() {
                  _currentSearchUrl = 'https://cse.google.com/cse?cx=$searchEngineId';
                });
              },
            ),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Search Input Field with Orange Theme
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                child: TextFormField(
                  controller: _model.searchController,
                  focusNode: _model.searchFocusNode,
                  onChanged: (_) => EasyDebounce.debounce(
                    '_model.searchController',
                    const Duration(milliseconds: 500),
                    () => safeSetState(() {}),
                  ),
                  onFieldSubmitted: (value) => _performSearch(value),
                  obscureText: false,
                  decoration: InputDecoration(
                    isDense: false,
                    labelText: 'Search the web...',
                    labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'SFPro',
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: Colors.orange,
                    ),
                    suffixIcon: _model.searchController.text.isNotEmpty
                        ? InkWell(
                            onTap: () => _performSearch(_model.searchController.text),
                            child: Icon(
                              Icons.send_rounded,
                              color: Colors.orange,
                              size: 22.0,
                            ),
                          )
                        : null,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'SFPro',
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
                  validator: _model.searchControllerValidator.asValidator(context),
                ),
              ),
              // Web View for Google Custom Search
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    /* border: Border.all(
                      color: Colors.orange.shade200,
                      width: 1.0,
                    ),*/
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    child: FlutterFlowWebView(
                      content: _currentSearchUrl,
                      bypass: true,
                      height: double.infinity,
                      verticalScroll: true,
                      horizontalScroll: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}