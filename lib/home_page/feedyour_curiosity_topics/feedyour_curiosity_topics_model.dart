import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/request_manager.dart';

import 'feedyour_curiosity_topics_widget.dart'
    show FeedyourCuriosityTopicsWidget;
import 'package:flutter/material.dart';

class FeedyourCuriosityTopicsModel
    extends FlutterFlowModel<FeedyourCuriosityTopicsWidget> {
  /// Query cache managers for this widget.

  final _page8Manager =
      FutureRequestManager<List<FeedYourCuriosityTopicsRow>>();
  Future<List<FeedYourCuriosityTopicsRow>> page8({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<FeedYourCuriosityTopicsRow>> Function() requestFn,
  }) =>
      _page8Manager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearPage8Cache() => _page8Manager.clear();
  void clearPage8CacheKey(String? uniqueKey) =>
      _page8Manager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    /// Dispose query cache managers for this widget.

    clearPage8Cache();
  }
}
