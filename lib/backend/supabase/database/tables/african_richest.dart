import '/backend/supabase/supabase.dart';

class AfricanRichestTable extends SupabaseTable<AfricanRichestRow> {
  @override
  String get tableName => 'africanRichest';

  @override
  AfricanRichestRow createRow(Map<String, dynamic> data) =>
      AfricanRichestRow(data);
}

class AfricanRichestRow extends SupabaseDataRow {
  AfricanRichestRow(super.data);

  @override
  SupabaseTable get table => AfricanRichestTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get networth => getField<String>('networth');
  set networth(String? value) => setField<String>('networth', value);

  int? get age => getField<int>('age');
  set age(int? value) => setField<int>('age', value);

  String? get pics => getField<String>('pics');
  set pics(String? value) => setField<String>('pics', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);
}