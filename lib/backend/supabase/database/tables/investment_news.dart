import '../database.dart';

class InvestmentNewsTable extends SupabaseTable<InvestmentNewsRow> {
  @override
  String get tableName => 'investmentNews';

  @override
  InvestmentNewsRow createRow(Map<String, dynamic> data) =>
      InvestmentNewsRow(data);
}

class InvestmentNewsRow extends SupabaseDataRow {
  InvestmentNewsRow(super.data);

  @override
  SupabaseTable get table => InvestmentNewsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get topicImageUrl => getField<String>('topicImageUrl');
  set topicImageUrl(String? value) => setField<String>('topicImageUrl', value);

  String? get images => getField<String>('Images');
  set images(String? value) => setField<String>('Images', value);
}
