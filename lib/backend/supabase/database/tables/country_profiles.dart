import '../database.dart';

class CountryProfilesTable extends SupabaseTable<CountryProfilesRow> {
  @override
  String get tableName => 'countryProfiles';

  @override
  CountryProfilesRow createRow(Map<String, dynamic> data) =>
      CountryProfilesRow(data);
}

class CountryProfilesRow extends SupabaseDataRow {
  CountryProfilesRow(super.data);

  @override
  SupabaseTable get table => CountryProfilesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get flagImageUrl => getField<String>('flagimage');
  set flagImageUrl(String? value) => setField<String>('flagimage', value);

  String? get countryGDP => getField<String>('gdp');
  set countryGDP(String? value) => setField<String>('gdp', value);

  String? get gdpRate => getField<String>('rateofgdp');
  set gdpRate(String? value) => setField<String>('rateofgdp', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  String? get population => getField<String>('population');
  set population(String? value) => setField<String>('population', value);
}
