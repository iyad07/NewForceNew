import '../database.dart';

class TradeandcommerceTable extends SupabaseTable<TradeandcommerceRow> {
  @override
  String get tableName => 'tradeandcommerce';

  @override
  TradeandcommerceRow createRow(Map<String, dynamic> data) =>
      TradeandcommerceRow(data);
}

class TradeandcommerceRow extends SupabaseDataRow {
  TradeandcommerceRow(super.data);

  @override
  SupabaseTable get table => TradeandcommerceTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get mainExport => getField<String>('main_export');
  set mainExport(String? value) => setField<String>('main_export', value);

  String? get topExport => getField<String>('top_export');
  set topExport(String? value) => setField<String>('top_export', value);

  String? get mainImport => getField<String>('main_import');
  set mainImport(String? value) => setField<String>('main_import', value);

  String? get topImport => getField<String>('top_import');
  set topImport(String? value) => setField<String>('top_import', value);

  String? get tradeAgreements => getField<String>('trade_agreements');
  set tradeAgreements(String? value) =>
      setField<String>('trade_agreements', value);
}
