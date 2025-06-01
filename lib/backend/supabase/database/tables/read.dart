import '../database.dart';

class ReadTable extends SupabaseTable<ReadRow> {
  @override
  String get tableName => 'read';

  @override
  ReadRow createRow(Map<String, dynamic> data) => ReadRow(data);
}

class ReadRow extends SupabaseDataRow {
  ReadRow(super.data);

  @override
  SupabaseTable get table => ReadTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);

  String? get readtime => getField<String>('readtime');
  set readtime(String? value) => setField<String>('readtime', value);
}
