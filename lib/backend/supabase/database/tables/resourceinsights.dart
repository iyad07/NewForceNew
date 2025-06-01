import '../database.dart';

class ResourceinsightsTable extends SupabaseTable<ResourceinsightsRow> {
  @override
  String get tableName => 'resourceinsights';

  @override
  ResourceinsightsRow createRow(Map<String, dynamic> data) =>
      ResourceinsightsRow(data);
}

class ResourceinsightsRow extends SupabaseDataRow {
  ResourceinsightsRow(super.data);

  @override
  SupabaseTable get table => ResourceinsightsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get resource => getField<String>('resource');
  set resource(String? value) => setField<String>('resource', value);

  String? get imageUrl => getField<String>('imageUrl');
  set imageUrl(String? value) => setField<String>('imageUrl', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get globalimpacts => getField<String>('globalimpacts');
  set globalimpacts(String? value) => setField<String>('globalimpacts', value);

  String? get keyindustries => getField<String>('keyindustries');
  set keyindustries(String? value) => setField<String>('keyindustries', value);

  String? get casestudies => getField<String>('casestudies');
  set casestudies(String? value) => setField<String>('casestudies', value);
}
