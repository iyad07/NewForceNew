import '../database.dart';

class TheCountryProfileTable extends SupabaseTable<TheCountryProfileRow> {
  @override
  String get tableName => 'theCountryProfiles';

  @override
  TheCountryProfileRow createRow(Map<String, dynamic> data) =>
      TheCountryProfileRow(data);
}

class TheCountryProfileRow extends SupabaseDataRow {
  TheCountryProfileRow(super.data);

  @override
  SupabaseTable get table => TheCountryProfileTable();

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get flagimage => getField<String>('flagimage');
  set flagimage(String? value) => setField<String>('flagimage', value);

  String? get gdp => getField<String>('gdp');
  set gdp(String? value) => setField<String>('gdp', value);

  String? get rateofgdp => getField<String>('rateofgdp');
  set rateofgdp(String? value) => setField<String>('rateofgdp', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  String? get population => getField<String>('population');
  set population(String? value) => setField<String>('population', value);

  double? get fdiinflows => getField<double>('fdiinflows');
  set fdiinflows(double? value) => setField<double>('fdiinflows', value);

  String? get keyindustries => getField<String>('keyindustries');
  set keyindustries(String? value) => setField<String>('keyindustries', value);

  double? get easeofbusiness => getField<double>('easeofbusiness');
  set easeofbusiness(double? value) => setField<double>('easeofbusiness', value);

  double? get corporatetaxpercentage => getField<double>('corporatetaxpercentage');
  set corporatetaxpercentage(double? value) => setField<double>('corporatetaxpercentage', value);

  double? get vatpercentage => getField<double>('vatpercentage');
  set vatpercentage(double? value) => setField<double>('vatpercentage', value);

  double? get witholdingtaxpercentage => getField<double>('witholdingtaxpercentage');
  set witholdingtaxpercentage(double? value) => setField<double>('witholdingtaxpercentage', value);

  double? get politicalstabilityindex => getField<double>('politicalstabilityindex');
  set politicalstabilityindex(double? value) => setField<double>('politicalstabilityindex', value);
}