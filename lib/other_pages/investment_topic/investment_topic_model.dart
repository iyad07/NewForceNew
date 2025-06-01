import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/request_manager.dart';

import 'investment_topic_widget.dart' show InvestmentTopicWidget;
import 'package:flutter/material.dart';

class InvestmentTopicModel extends FlutterFlowModel<InvestmentTopicWidget> {
  /// Query cache managers for this widget.

  final _pagelevelManager =
      FutureRequestManager<List<InvestementNewsArticlesRow>>();
  Future<List<InvestementNewsArticlesRow>> pagelevel({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<InvestementNewsArticlesRow>> Function() requestFn,
  }) =>
      _pagelevelManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearPagelevelCache() => _pagelevelManager.clear();
  void clearPagelevelCacheKey(String? uniqueKey) =>
      _pagelevelManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    /// Dispose query cache managers for this widget.

    clearPagelevelCache();
  }
}
