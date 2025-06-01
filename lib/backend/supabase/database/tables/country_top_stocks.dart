import '../database.dart';

class CountryTopStocksTable extends SupabaseTable<CountryTopStocksRow> {
  @override
  String get tableName => 'countryTopStocks';

  @override
  CountryTopStocksRow createRow(Map<String, dynamic> data) =>
      CountryTopStocksRow(data);
}

class CountryTopStocksRow extends SupabaseDataRow {
  CountryTopStocksRow(super.data);

  @override
  SupabaseTable get table => CountryTopStocksTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get stockName => getField<String>('stockName');
  set stockName(String? value) => setField<String>('stockName', value);

  int? get stockRate => getField<int>('stockRate');
  set stockRate(int? value) => setField<int>('stockRate', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);
}
