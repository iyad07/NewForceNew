import '../database.dart';

class AgricultureTable extends SupabaseTable<AgricultureRow> {
  @override
  String get tableName => 'agriculture';

  @override
  AgricultureRow createRow(Map<String, dynamic> data) => AgricultureRow(data);
}

class AgricultureRow extends SupabaseDataRow {
  AgricultureRow(super.data);

  @override
  SupabaseTable get table => AgricultureTable();

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

  String? get articleBody => getField<String>('articleBody');
  set articleBody(String? value) => setField<String>('articleBody', value);
}
