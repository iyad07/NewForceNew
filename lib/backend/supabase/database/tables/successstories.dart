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



  String? get title => getField<String>('Title');
  set title(String? value) => setField<String>('Title', value);

  String? get description => getField<String>('Description');
  set description(String? value) => setField<String>('Description', value);

  String? get sector => getField<String>('Sector');
  set sector(String? value) => setField<String>('Sector', value);

  String? get country => getField<String>('Country');
  set country(String? value) => setField<String>('Country', value);

  String? get impactMetrics => getField<String>('Impact Metrics');
  set impactMetrics(String? value) => setField<String>('Impact Metrics', value);

  String? get imageUrl => getField<String>('Image URL');
  set imageUrl(String? value) => setField<String>('Image URL', value);
}
