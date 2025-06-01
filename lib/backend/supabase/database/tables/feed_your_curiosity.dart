import '../database.dart';

class FeedYourCuriosityTable extends SupabaseTable<FeedYourCuriosityRow> {
  @override
  String get tableName => 'feedYourCuriosity';

  @override
  FeedYourCuriosityRow createRow(Map<String, dynamic> data) =>
      FeedYourCuriosityRow(data);
}

class FeedYourCuriosityRow extends SupabaseDataRow {
  FeedYourCuriosityRow(super.data);

  @override
  SupabaseTable get table => FeedYourCuriosityTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get publisher => getField<String>('publisher');
  set publisher(String? value) => setField<String>('publisher', value);

  String? get readtime => getField<String>('readtime');
  set readtime(String? value) => setField<String>('readtime', value);
}
