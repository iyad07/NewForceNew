import '../database.dart';

class SuccessstoriesTable extends SupabaseTable<SuccessstoriesRow> {
  @override
  String get tableName => 'successstories';

  @override
  SuccessstoriesRow createRow(Map<String, dynamic> data) =>
      SuccessstoriesRow(data);
}

class SuccessstoriesRow extends SupabaseDataRow {
  SuccessstoriesRow(super.data);

  @override
  SupabaseTable get table => SuccessstoriesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get industry => getField<String>('industry');
  set industry(String? value) => setField<String>('industry', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get achievements => getField<String>('achievements');
  set achievements(String? value) => setField<String>('achievements', value);

  String? get keyfigures => getField<String>('keyfigures');
  set keyfigures(String? value) => setField<String>('keyfigures', value);
}
