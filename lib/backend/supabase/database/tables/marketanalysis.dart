import '../database.dart';

class MarketanalysisTable extends SupabaseTable<MarketanalysisRow> {
  @override
  String get tableName => 'marketanalysis';

  @override
  MarketanalysisRow createRow(Map<String, dynamic> data) =>
      MarketanalysisRow(data);
}

class MarketanalysisRow extends SupabaseDataRow {
  MarketanalysisRow(super.data);

  @override
  SupabaseTable get table => MarketanalysisTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get consumermarket => getField<String>('consumermarket');
  set consumermarket(String? value) =>
      setField<String>('consumermarket', value);

  String? get keyindustries => getField<String>('keyindustries');
  set keyindustries(String? value) => setField<String>('keyindustries', value);

  String? get markettrends => getField<String>('markettrends');
  set markettrends(String? value) => setField<String>('markettrends', value);

  String? get competition => getField<String>('competition');
  set competition(String? value) => setField<String>('competition', value);
}
