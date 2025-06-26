import '/flutter_flow/flutter_flow_util.dart';
import 'natural_resources_widget.dart' show NaturalResourcesWidget;
import 'package:flutter/material.dart';
import 'dart:async';
import '/backend/supabase/database/tables/africa_resources.dart';
import '/backend/supabase/supabase.dart';

class NaturalResourcesModel extends FlutterFlowModel<NaturalResourcesWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for PageView widget.
  late PageController pageViewController;
  // Auto-slide timers
  Timer? autoSlideTimer;
  
  // Supabase data
  List<AfricaResourcesRow>? africaResourcesData;
  bool isLoading = true;
  String? errorMessage;
  
  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
      


  @override
  void initState(BuildContext context) {
    pageViewController = PageController();
  }
  
  // Fetch data from Supabase
  Future<void> fetchAfricaResourcesData() async {
    try {
      isLoading = true;
      errorMessage = null;
      
      final response = await SupaFlow.client
          .from('africaResources')
          .select()
          .order('resource', ascending: true);
      
      africaResourcesData = response
          .map((data) => AfricaResourcesRow(data))
          .toList();
      
      isLoading = false;
    } catch (e) {
      isLoading = false;
      errorMessage = 'Error fetching data: $e';
    }
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    autoSlideTimer?.cancel();
    pageViewController?.dispose();
  }
}