import '../database.dart';

class FeedyourcuriosityTable extends SupabaseTable<FeedyourcuriosityRow> {
  @override
  String get tableName => 'feedyourcuriosity';

  @override
  FeedyourcuriosityRow createRow(Map<String, dynamic> data) =>
      FeedyourcuriosityRow(data);
}

class FeedyourcuriosityRow extends SupabaseDataRow {
  FeedyourcuriosityRow(super.data);

  @override
  SupabaseTable get table => FeedyourcuriosityTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);
}
