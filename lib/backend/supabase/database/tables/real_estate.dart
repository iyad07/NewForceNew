import '../database.dart';

class RealEstateTable extends SupabaseTable<RealEstateRow> {
  @override
  String get tableName => 'realEstate';

  @override
  RealEstateRow createRow(Map<String, dynamic> data) => RealEstateRow(data);
}

class RealEstateRow extends SupabaseDataRow {
  RealEstateRow(super.data);

  @override
  SupabaseTable get table => RealEstateTable();

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

  String? get articleBoday => getField<String>('articleBoday');
  set articleBoday(String? value) => setField<String>('articleBoday', value);
}
