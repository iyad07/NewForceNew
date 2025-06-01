import '../database.dart';

class GeneralinformatioinTable extends SupabaseTable<GeneralinformatioinRow> {
  @override
  String get tableName => 'generalinformatioin';

  @override
  GeneralinformatioinRow createRow(Map<String, dynamic> data) =>
      GeneralinformatioinRow(data);
}

class GeneralinformatioinRow extends SupabaseDataRow {
  GeneralinformatioinRow(super.data);

  @override
  SupabaseTable get table => GeneralinformatioinTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get capitalcity => getField<String>('capitalcity');
  set capitalcity(String? value) => setField<String>('capitalcity', value);

  String? get officiallanguage => getField<String>('officiallanguage');
  set officiallanguage(String? value) =>
      setField<String>('officiallanguage', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  String? get population => getField<String>('population');
  set population(String? value) => setField<String>('population', value);

  String? get geographicallocation => getField<String>('geographicallocation');
  set geographicallocation(String? value) =>
      setField<String>('geographicallocation', value);

  String? get flagimageUrl => getField<String>('flagimageUrl');
  set flagimageUrl(String? value) => setField<String>('flagimageUrl', value);
}
