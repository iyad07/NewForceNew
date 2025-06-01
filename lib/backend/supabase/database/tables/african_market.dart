import '../database.dart';

class AfricanMarketTable extends SupabaseTable<AfricanMarketRow> {
  @override
  String get tableName => 'africanMarket';

  @override
  AfricanMarketRow createRow(Map<String, dynamic> data) =>
      AfricanMarketRow(data);
}

class AfricanMarketRow extends SupabaseDataRow {
  AfricanMarketRow(super.data);

  @override
  SupabaseTable get table => AfricanMarketTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get articleImage => getField<String>('articleImage');
  set articleImage(String? value) => setField<String>('articleImage', value);

  String? get articleTitle => getField<String>('articleTitle');
  set articleTitle(String? value) => setField<String>('articleTitle', value);

  String? get articleDescription => getField<String>('articleDescription');
  set articleDescription(String? value) =>
      setField<String>('articleDescription', value);

  String? get articleBody => getField<String>('articleBody');
  set articleBody(String? value) => setField<String>('articleBody', value);
}
