import '../database.dart';

class MapDetailsTable extends SupabaseTable<MapDetailsRow> {
  @override
  String get tableName => 'mapDetails';

  @override
  MapDetailsRow createRow(Map<String, dynamic> data) => MapDetailsRow(data);
}

class MapDetailsRow extends SupabaseDataRow {
  MapDetailsRow(super.data);

  @override
  SupabaseTable get table => MapDetailsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
