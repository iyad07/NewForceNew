import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/request_manager.dart';

import 'business_index_widget.dart' show BusinessIndexWidget;
import 'package:flutter/material.dart';

class BusinessIndexModel extends FlutterFlowModel<BusinessIndexWidget> {
  /// Query cache managers for this widget.

  final _economicIndicatorsManager =
      FutureRequestManager<List<EconomicindicatorsRow>>();
  Future<List<EconomicindicatorsRow>> economicIndicators({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<EconomicindicatorsRow>> Function() requestFn,
  }) =>
      _economicIndicatorsManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearEconomicIndicatorsCache() => _economicIndicatorsManager.clear();
  void clearEconomicIndicatorsCacheKey(String? uniqueKey) =>
      _economicIndicatorsManager.clearRequest(uniqueKey);

  final _africanMarketManager = FutureRequestManager<List<AfricanMarketRow>>();
  Future<List<AfricanMarketRow>> africanMarket({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<AfricanMarketRow>> Function() requestFn,
  }) =>
      _africanMarketManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearAfricanMarketCache() => _africanMarketManager.clear();
  void clearAfricanMarketCacheKey(String? uniqueKey) =>
      _africanMarketManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    _economicIndicatorsManager.clear();
    _africanMarketManager.clear();
  }
}