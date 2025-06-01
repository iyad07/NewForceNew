import '../database.dart';

class CountryInfluencialProfilesTable
    extends SupabaseTable<CountryInfluencialProfilesRow> {
  @override
  String get tableName => 'countryInfluencialProfiles';

  @override
  CountryInfluencialProfilesRow createRow(Map<String, dynamic> data) =>
      CountryInfluencialProfilesRow(data);
}

class CountryInfluencialProfilesRow extends SupabaseDataRow {
  CountryInfluencialProfilesRow(super.data);

  @override
  SupabaseTable get table => CountryInfluencialProfilesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get nationality => getField<String>('nationality');
  set nationality(String? value) => setField<String>('nationality', value);

  String? get networth => getField<String>('networth');
  set networth(String? value) => setField<String>('networth', value);

  String? get profession => getField<String>('profession');
  set profession(String? value) => setField<String>('profession', value);

  String? get bio => getField<String>('bio');
  set bio(String? value) => setField<String>('bio', value);

  String? get contributions => getField<String>('contributions');
  set contributions(String? value) => setField<String>('contributions', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);
}
