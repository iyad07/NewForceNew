import '../database.dart';

class CountryProfileNewsTable extends SupabaseTable<CountryProfileNewsRow> {
  @override
  String get tableName => 'countryProfileNews';

  @override
  CountryProfileNewsRow createRow(Map<String, dynamic> data) =>
      CountryProfileNewsRow(data);
}

class CountryProfileNewsRow extends SupabaseDataRow {
  CountryProfileNewsRow(super.data);

  @override
  SupabaseTable get table => CountryProfileNewsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get newsBody => getField<String>('newsBody');
  set newsBody(String? value) => setField<String>('newsBody', value);
}
