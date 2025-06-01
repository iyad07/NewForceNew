import '../database.dart';

class EconomicindicatorsTable extends SupabaseTable<EconomicindicatorsRow> {
  @override
  String get tableName => 'economicindicators';

  @override
  EconomicindicatorsRow createRow(Map<String, dynamic> data) =>
      EconomicindicatorsRow(data);
}

class EconomicindicatorsRow extends SupabaseDataRow {
  EconomicindicatorsRow(super.data);

  @override
  SupabaseTable get table => EconomicindicatorsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get gdp => getField<String>('GDP');
  set gdp(String? value) => setField<String>('GDP', value);

  String? get unemploymentrate => getField<String>('unemploymentrate');
  set unemploymentrate(String? value) =>
      setField<String>('unemploymentrate', value);

  String? get keyeconomicsectors => getField<String>('keyeconomicsectors');
  set keyeconomicsectors(String? value) =>
      setField<String>('keyeconomicsectors', value);
}
