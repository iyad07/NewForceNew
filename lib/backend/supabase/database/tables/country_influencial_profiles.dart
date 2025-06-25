import '../database.dart';

class CountryInfluencialProfilesTable
    extends SupabaseTable<CountryInfluencialProfilesRow> {
  @override
  String get tableName => 'influentialFigures';

  @override
  CountryInfluencialProfilesRow createRow(Map<String, dynamic> data) =>
      CountryInfluencialProfilesRow(data);
}

class CountryInfluencialProfilesRow extends SupabaseDataRow {
  CountryInfluencialProfilesRow(super.data);

  @override
  SupabaseTable get table => CountryInfluencialProfilesTable();

  String? get name => getField<String>('Name');
  set name(String? value) => setField<String>('Name', value);

  String? get country => getField<String>('Country');
  set country(String? value) => setField<String>('Country', value);

  String? get company => getField<String>('Company');
  set company(String? value) => setField<String>('Company', value);

  String? get achievements => getField<String>('Achievements');
  set achievements(String? value) => setField<String>('Achievements', value);

  String? get image => getField<String>('Image');
  set image(String? value) => setField<String>('Image', value);
}
