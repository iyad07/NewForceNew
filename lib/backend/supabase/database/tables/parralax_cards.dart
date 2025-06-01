import '../database.dart';

class ParralaxCardsTable extends SupabaseTable<ParralaxCardsRow> {
  @override
  String get tableName => 'parralaxCards';

  @override
  ParralaxCardsRow createRow(Map<String, dynamic> data) =>
      ParralaxCardsRow(data);
}

class ParralaxCardsRow extends SupabaseDataRow {
  ParralaxCardsRow(super.data);

  @override
  SupabaseTable get table => ParralaxCardsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get text => getField<String>('text');
  set text(String? value) => setField<String>('text', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);
}
