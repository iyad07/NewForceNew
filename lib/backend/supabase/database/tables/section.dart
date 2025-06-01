import '../database.dart';

class SectionTable extends SupabaseTable<SectionRow> {
  @override
  String get tableName => 'section';

  @override
  SectionRow createRow(Map<String, dynamic> data) => SectionRow(data);
}

class SectionRow extends SupabaseDataRow {
  SectionRow(super.data);

  @override
  SupabaseTable get table => SectionTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get imageUrl => getField<String>('imageUrl');
  set imageUrl(String? value) => setField<String>('imageUrl', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);
}
