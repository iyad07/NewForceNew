import '../database.dart';

class FeedYourCuriosityTopicsTable
    extends SupabaseTable<FeedYourCuriosityTopicsRow> {
  @override
  String get tableName => 'feedYourCuriosityTopics';

  @override
  FeedYourCuriosityTopicsRow createRow(Map<String, dynamic> data) =>
      FeedYourCuriosityTopicsRow(data);
}

class FeedYourCuriosityTopicsRow extends SupabaseDataRow {
  FeedYourCuriosityTopicsRow(super.data);

  @override
  SupabaseTable get table => FeedYourCuriosityTopicsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);

  String? get publisher => getField<String>('publisher');
  set publisher(String? value) => setField<String>('publisher', value);

  String? get newsDescription => getField<String>('newsDescription');
  set newsDescription(String? value) =>
      setField<String>('newsDescription', value);

  String? get publisherImageUrl => getField<String>('publisherImageUrl');
  set publisherImageUrl(String? value) =>
      setField<String>('publisherImageUrl', value);

  String? get tag => getField<String>('tag');
  set tag(String? value) => setField<String>('tag', value);

  String? get newsBody => getField<String>('newsBody');
  set newsBody(String? value) => setField<String>('newsBody', value);
}
