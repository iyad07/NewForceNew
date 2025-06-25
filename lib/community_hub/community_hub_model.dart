import '/flutter_flow/flutter_flow_util.dart';
import 'community_hub_widget.dart' show CommunityHubWidget;
import '/backend/supabase/supabase.dart';
import 'package:flutter/material.dart';

class CommunityHubModel extends FlutterFlowModel<CommunityHubWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  
  // Cache for topics data
  List<TopicsRow>? _cachedTopics;
  DateTime? _lastCacheTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);
  
  // Loading states
  bool _isLoadingTopics = false;
  Future<List<TopicsRow>>? _topicsLoadingFuture;

  @override
  void initState(BuildContext context) {
    // Start preloading topics in background
    _preloadTopics();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
  }
  
  // Preload topics in background (private)
  void _preloadTopics() {
    if (!_isLoadingTopics && !_isCacheValid()) {
      _topicsLoadingFuture = _fetchTopicsOptimized();
    }
  }
  
  // Public method to trigger preloading
  void preloadTopics() {
    _preloadTopics();
  }
  
  // Check if cache is still valid
  bool _isCacheValid() {
    if (_cachedTopics == null || _lastCacheTime == null) return false;
    return DateTime.now().difference(_lastCacheTime!) < _cacheValidDuration;
  }
  
  // Get topics with caching and background loading
  Future<List<TopicsRow>> getTopics() async {
    // Return cached data if valid
    if (_isCacheValid()) {
      return _cachedTopics!;
    }
    
    // If already loading, wait for that future
    if (_topicsLoadingFuture != null) {
      return await _topicsLoadingFuture!;
    }
    
    // Start new loading
    _topicsLoadingFuture = _fetchTopicsOptimized();
    return await _topicsLoadingFuture!;
  }
  
  // Optimized topics fetching with single query
  Future<List<TopicsRow>> _fetchTopicsOptimized() async {
    if (_isLoadingTopics) return _cachedTopics ?? [];
    
    _isLoadingTopics = true;
    try {
      // Use a more efficient query - get topics with post counts in single query
      final topics = await TopicsTable().queryRows(
        queryFn: (q) => q
            .eq('is_active', true)
            .order('created_at', ascending: false),
      );
      
      // Cache the results
      _cachedTopics = topics;
      _lastCacheTime = DateTime.now();
      _topicsLoadingFuture = null;
      
      return topics;
    } catch (e) {
      debugPrint('Error fetching topics: $e');
      _topicsLoadingFuture = null;
      return _cachedTopics ?? [];
    } finally {
      _isLoadingTopics = false;
    }
  }
  
  // Refresh topics (force reload)
  Future<List<TopicsRow>> refreshTopics() async {
    _cachedTopics = null;
    _lastCacheTime = null;
    _topicsLoadingFuture = null;
    return await getTopics();
  }
  
  // Check if topics are currently loading
  bool get isLoadingTopics => _isLoadingTopics;
  
  // Get cached topics immediately (for instant display)
  List<TopicsRow>? get cachedTopics => _cachedTopics;
}