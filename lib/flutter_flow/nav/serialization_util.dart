import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';

import '/backend/supabase/supabase.dart';

import '../../flutter_flow/place.dart';
import '../../flutter_flow/uploaded_file.dart';

/// SERIALIZATION HELPERS

String dateTimeRangeToString(DateTimeRange dateTimeRange) {
  final startStr = dateTimeRange.start.millisecondsSinceEpoch.toString();
  final endStr = dateTimeRange.end.millisecondsSinceEpoch.toString();
  return '$startStr|$endStr';
}

String placeToString(FFPlace place) => jsonEncode({
      'latLng': place.latLng.serialize(),
      'name': place.name,
      'address': place.address,
      'city': place.city,
      'state': place.state,
      'country': place.country,
      'zipCode': place.zipCode,
    });

String uploadedFileToString(FFUploadedFile uploadedFile) =>
    uploadedFile.serialize();

String? serializeParam(
  dynamic param,
  ParamType paramType, {
  bool isList = false,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final serializedValues = (param as Iterable)
          .map((p) => serializeParam(p, paramType, isList: false))
          .where((p) => p != null)
          .map((p) => p!)
          .toList();
      return json.encode(serializedValues);
    }
    String? data;
    switch (paramType) {
      case ParamType.int:
        data = param.toString();
      case ParamType.double:
        data = param.toString();
      case ParamType.String:
        data = param;
      case ParamType.bool:
        data = param ? 'true' : 'false';
      case ParamType.DateTime:
        data = (param as DateTime).millisecondsSinceEpoch.toString();
      case ParamType.DateTimeRange:
        data = dateTimeRangeToString(param as DateTimeRange);
      case ParamType.LatLng:
        data = (param as LatLng).serialize();
      case ParamType.Color:
        data = (param as Color).toCssString();
      case ParamType.FFPlace:
        data = placeToString(param as FFPlace);
      case ParamType.FFUploadedFile:
        data = uploadedFileToString(param as FFUploadedFile);
      case ParamType.JSON:
        data = json.encode(param);

      case ParamType.SupabaseRow:
        return json.encode((param as SupabaseDataRow).data);

      default:
        data = null;
    }
    return data;
  } catch (e) {
    print('Error serializing parameter: $e');
    return null;
  }
}

/// END SERIALIZATION HELPERS

/// DESERIALIZATION HELPERS

DateTimeRange? dateTimeRangeFromString(String dateTimeRangeStr) {
  final pieces = dateTimeRangeStr.split('|');
  if (pieces.length != 2) {
    return null;
  }
  return DateTimeRange(
    start: DateTime.fromMillisecondsSinceEpoch(int.parse(pieces.first)),
    end: DateTime.fromMillisecondsSinceEpoch(int.parse(pieces.last)),
  );
}

LatLng? latLngFromString(String? latLngStr) {
  final pieces = latLngStr?.split(',');
  if (pieces == null || pieces.length != 2) {
    return null;
  }
  return LatLng(
    double.parse(pieces.first.trim()),
    double.parse(pieces.last.trim()),
  );
}

FFPlace placeFromString(String placeStr) {
  final serializedData = jsonDecode(placeStr) as Map<String, dynamic>;
  final data = {
    'latLng': serializedData.containsKey('latLng')
        ? latLngFromString(serializedData['latLng'] as String)
        : const LatLng(0.0, 0.0),
    'name': serializedData['name'] ?? '',
    'address': serializedData['address'] ?? '',
    'city': serializedData['city'] ?? '',
    'state': serializedData['state'] ?? '',
    'country': serializedData['country'] ?? '',
    'zipCode': serializedData['zipCode'] ?? '',
  };
  return FFPlace(
    latLng: data['latLng'] as LatLng,
    name: data['name'] as String,
    address: data['address'] as String,
    city: data['city'] as String,
    state: data['state'] as String,
    country: data['country'] as String,
    zipCode: data['zipCode'] as String,
  );
}

FFUploadedFile uploadedFileFromString(String uploadedFileStr) =>
    FFUploadedFile.deserialize(uploadedFileStr);

enum ParamType {
  int,
  double,
  String,
  bool,
  DateTime,
  DateTimeRange,
  LatLng,
  Color,
  FFPlace,
  FFUploadedFile,
  JSON,

  SupabaseRow,
}

dynamic deserializeParam<T>(
  String? param,
  ParamType paramType,
  bool isList,
) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final paramValues = json.decode(param);
      if (paramValues is! Iterable || paramValues.isEmpty) {
        return null;
      }
      return paramValues
          .whereType<String>()
          .map((p) => p)
          .map((p) => deserializeParam<T>(p, paramType, false))
          .where((p) => p != null)
          .map((p) => p! as T)
          .toList();
    }
    switch (paramType) {
      case ParamType.int:
        return int.tryParse(param);
      case ParamType.double:
        return double.tryParse(param);
      case ParamType.String:
        return param;
      case ParamType.bool:
        return param == 'true';
      case ParamType.DateTime:
        final milliseconds = int.tryParse(param);
        return milliseconds != null
            ? DateTime.fromMillisecondsSinceEpoch(milliseconds)
            : null;
      case ParamType.DateTimeRange:
        return dateTimeRangeFromString(param);
      case ParamType.LatLng:
        return latLngFromString(param);
      case ParamType.Color:
        return fromCssColor(param);
      case ParamType.FFPlace:
        return placeFromString(param);
      case ParamType.FFUploadedFile:
        return uploadedFileFromString(param);
      case ParamType.JSON:
        return json.decode(param);

      case ParamType.SupabaseRow:
        final data = json.decode(param) as Map<String, dynamic>;
        switch (T) {
          case InvestmentNewsRow:
            return InvestmentNewsRow(data);
          case GeneralinformatioinRow:
            return GeneralinformatioinRow(data);
          case CountryInfluencialProfilesRow:
            return CountryInfluencialProfilesRow(data);
          case AfricanTourismRow:
            return AfricanTourismRow(data);
          case CountryProfileNewsRow:
            return CountryProfileNewsRow(data);
          case SocialandculturalfactorsRow:
            return SocialandculturalfactorsRow(data);
          case ReadRow:
            return ReadRow(data);
          case TopReadArticlesRow:
            return TopReadArticlesRow(data);
          case EditorsRecommendationArticlesRow:
            return EditorsRecommendationArticlesRow(data);
          case FeedYourCuriosityTopicsRow:
            return FeedYourCuriosityTopicsRow(data);
          case SuccessstoriesRow:
            return SuccessstoriesRow(data);
          case CountryTopStocksRow:
            return CountryTopStocksRow(data);
          case ChatRow:
            return ChatRow(data);
          case UpvotesRow:
            return UpvotesRow(data);
          case MarketanalysisRow:
            return MarketanalysisRow(data);
          case EditorrecommendationRow:
            return EditorrecommendationRow(data);
          case PostsRow:
            return PostsRow(data);
          case ShortVideosRow:
            return ShortVideosRow(data);
          case SectionRow:
            return SectionRow(data);
          case AfricanIndustriesRow:
            return AfricanIndustriesRow(data);
          case RealEstateRow:
            return RealEstateRow(data);
          case AfricanMarketRow:
            return AfricanMarketRow(data);
          case InvestementNewsArticlesRow:
            return InvestementNewsArticlesRow(data);
          case InfrastructureandresourcesRow:
            return InfrastructureandresourcesRow(data);
          case CountryProfilesRow:
            return CountryProfilesRow(data);
          case ProfileRow:
            return ProfileRow(data);
          case AgricultureRow:
            return AgricultureRow(data);
          case HistoricEventsRow:
            return HistoricEventsRow(data);
          case AfricasTechnologyRow:
            return AfricasTechnologyRow(data);
          case TradeandcommerceRow:
            return TradeandcommerceRow(data);
          case CommentsRow:
            return CommentsRow(data);
          case PoliticalandlegalenvironmentRow:
            return PoliticalandlegalenvironmentRow(data);
          case AfricanPoliticsRow:
            return AfricanPoliticsRow(data);
          case OnboardingMapRow:
            return OnboardingMapRow(data);
          case ConversationRow:
            return ConversationRow(data);
          case CultuerandlifestyleRow:
            return CultuerandlifestyleRow(data);
          case EducationRow:
            return EducationRow(data);
          case ParralaxCardsRow:
            return ParralaxCardsRow(data);
          case MapDetailsRow:
            return MapDetailsRow(data);
          case NewForceArticlesRow:
            return NewForceArticlesRow(data);
          case AfricasArtRow:
            return AfricasArtRow(data);
          case WildlifeRow:
            return WildlifeRow(data);
          case FeedyourcuriosityRow:
            return FeedyourcuriosityRow(data);
          case FeedYourCuriosityRow:
            return FeedYourCuriosityRow(data);
          case ResourceinsightsRow:
            return ResourceinsightsRow(data);
          case EconomicindicatorsRow:
            return EconomicindicatorsRow(data);
          default:
            return null;
        }

      default:
        return null;
    }
  } catch (e) {
    print('Error deserializing parameter: $e');
    return null;
  }
}
