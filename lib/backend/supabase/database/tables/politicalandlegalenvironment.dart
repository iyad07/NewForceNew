import '../database.dart';

class PoliticalandlegalenvironmentTable
    extends SupabaseTable<PoliticalandlegalenvironmentRow> {
  @override
  String get tableName => 'politicalandlegalenvironment';

  @override
  PoliticalandlegalenvironmentRow createRow(Map<String, dynamic> data) =>
      PoliticalandlegalenvironmentRow(data);
}

class PoliticalandlegalenvironmentRow extends SupabaseDataRow {
  PoliticalandlegalenvironmentRow(super.data);

  @override
  SupabaseTable get table => PoliticalandlegalenvironmentTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get govenrmenttype => getField<String>('govenrmenttype');
  set govenrmenttype(String? value) =>
      setField<String>('govenrmenttype', value);

  String? get politicalstability => getField<String>('politicalstability');
  set politicalstability(String? value) =>
      setField<String>('politicalstability', value);

  String? get legalsystem => getField<String>('legalsystem');
  set legalsystem(String? value) => setField<String>('legalsystem', value);

  String? get investmentlaws => getField<String>('investmentlaws');
  set investmentlaws(String? value) =>
      setField<String>('investmentlaws', value);

  String? get taxationpolicy => getField<String>('taxationpolicy');
  set taxationpolicy(String? value) =>
      setField<String>('taxationpolicy', value);
}
