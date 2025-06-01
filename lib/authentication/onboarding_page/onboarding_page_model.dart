import 'package:flutter/services.dart';
import 'package:new_force_new_hope/authentication/onboarding_page/onboarding_page_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
//import 'onboarding_page_widget.dart' show OnboardingPageWidget;
import 'package:flutter/material.dart';

class OnboardingPageModel extends FlutterFlowModel<OnboardingPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

Future<List<MapModel>> parseJsonFileToMapModels() async {
  final String jsonString =
      await rootBundle.loadString('assets/africaMap.json');
  final data = jsonDecode(jsonString)['features'] as List;
  return data.map((json) => MapModel.fromJson(json)).toList();
}

class MapModel {
  MapModel(this.name, this.abbrev, this.color, this.population, this.gdp,
      this.incomeGroup, this.region);

  final String name;
  final String abbrev;
  final Color color;
  final dynamic population;
  final dynamic gdp;
  final String incomeGroup;
  final String region;

  // Factory method to create a MapModel from JSON data
  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      json['properties']['name'],
      json['properties']['abbrev'],
      _mapColor(json['properties']['mapcolor13']),
      json['properties']['pop_est'],
      json['properties']['gdp_md_est'],
      json['properties']['income_grp'],
      json['properties']['region_un'],
    );
  }

  // Helper method to map color values
  static Color _mapColor(int colorCode) {
    switch (colorCode) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      case 4:
        return Colors.yellow;
      case 5:
        return Colors.orange;
      case 6:
        return Colors.purple;
      case 7:
        return Colors.pink;
      case 8:
        return Colors.brown;
      default:
        return Colors.black;
    }
  }
}
