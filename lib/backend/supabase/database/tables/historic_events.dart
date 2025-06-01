import '../database.dart';

class HistoricEventsTable extends SupabaseTable<HistoricEventsRow> {
  @override
  String get tableName => 'historicEvents';

  @override
  HistoricEventsRow createRow(Map<String, dynamic> data) =>
      HistoricEventsRow(data);
}

class HistoricEventsRow extends SupabaseDataRow {
  HistoricEventsRow(super.data);

  @override
  SupabaseTable get table => HistoricEventsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime? get date => getField<DateTime>('date');
  set date(DateTime? value) => setField<DateTime>('date', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);
}
