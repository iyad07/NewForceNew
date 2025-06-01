import '../database.dart';

class AfricanIndustriesTable extends SupabaseTable<AfricanIndustriesRow> {
  @override
  String get tableName => 'africanIndustries';

  @override
  AfricanIndustriesRow createRow(Map<String, dynamic> data) =>
      AfricanIndustriesRow(data);
}

class AfricanIndustriesRow extends SupabaseDataRow {
  AfricanIndustriesRow(super.data);

  @override
  SupabaseTable get table => AfricanIndustriesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get articleImage => getField<String>('articleImage');
  set articleImage(String? value) => setField<String>('articleImage', value);

  String? get articleTitle => getField<String>('articleTitle');
  set articleTitle(String? value) => setField<String>('articleTitle', value);

  String? get articleDescription => getField<String>('articleDescription');
  set articleDescription(String? value) =>
      setField<String>('articleDescription', value);

  String? get articleBoday => getField<String>('articleBoday');
  set articleBoday(String? value) => setField<String>('articleBoday', value);
}
