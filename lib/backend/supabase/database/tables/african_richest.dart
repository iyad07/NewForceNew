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

  String? get name => getField<String>('Name');
  set name(String? value) => setField<String>('Name', value);

  String? get networth => getField<String>('Networth');
  set networth(String? value) => setField<String>('Networth', value);

  int? get age => getField<int>('Age');
  set age(int? value) => setField<int>('Age', value);

  String? get pics => getField<String>('Pics');
  set pics(String? value) => setField<String>('Pics', value);

  String? get descriptions => getField<String>('Descriptions');
  set descriptions(String? value) => setField<String>('Descriptions', value);
}