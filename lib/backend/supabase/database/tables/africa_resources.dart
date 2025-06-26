import '../database.dart';

class AfricaResourcesTable extends SupabaseTable<AfricaResourcesRow> {
  @override
  String get tableName => 'africaResources';

  @override
  AfricaResourcesRow createRow(Map<String, dynamic> data) =>
      AfricaResourcesRow(data);
}

class AfricaResourcesRow extends SupabaseDataRow {
  AfricaResourcesRow(super.data);

  @override
  SupabaseTable get table => AfricaResourcesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get resource => getField<String>('resource');
  set resource(String? value) => setField<String>('resource', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get exportValue => getField<String>('exportValue');
  set exportValue(String? value) => setField<String>('exportValue', value);

  String? get globalRank => getField<String>('globalRank');
  set globalRank(String? value) => setField<String>('globalRank', value);

  String? get percentage => getField<String>('percentage');
  set percentage(String? value) => setField<String>('percentage', value);

  String? get productionVolume => getField<String>('productionVolume');
  set productionVolume(String? value) => setField<String>('productionVolume', value);

  String? get majorDestination => getField<String>('majorDestination');
  set majorDestination(String? value) => setField<String>('majorDestination', value);

  String? get year => getField<String>('year');
  set year(String? value) => setField<String>('year', value);
}