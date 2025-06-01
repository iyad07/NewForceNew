import '../database.dart';

class InfrastructureandresourcesTable
    extends SupabaseTable<InfrastructureandresourcesRow> {
  @override
  String get tableName => 'infrastructureandresources';

  @override
  InfrastructureandresourcesRow createRow(Map<String, dynamic> data) =>
      InfrastructureandresourcesRow(data);
}

class InfrastructureandresourcesRow extends SupabaseDataRow {
  InfrastructureandresourcesRow(super.data);

  @override
  SupabaseTable get table => InfrastructureandresourcesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get transportationnetworks =>
      getField<String>('transportationnetworks');
  set transportationnetworks(String? value) =>
      setField<String>('transportationnetworks', value);

  String? get utilities => getField<String>('utilities');
  set utilities(String? value) => setField<String>('utilities', value);

  String? get naturalresources => getField<String>('naturalresources');
  set naturalresources(String? value) =>
      setField<String>('naturalresources', value);

  String? get telecommunications => getField<String>('telecommunications');
  set telecommunications(String? value) =>
      setField<String>('telecommunications', value);
}
