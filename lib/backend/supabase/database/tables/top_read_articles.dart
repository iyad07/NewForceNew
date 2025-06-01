import '../database.dart';

class TopReadArticlesTable extends SupabaseTable<TopReadArticlesRow> {
  @override
  String get tableName => 'topReadArticles';

  @override
  TopReadArticlesRow createRow(Map<String, dynamic> data) =>
      TopReadArticlesRow(data);
}

class TopReadArticlesRow extends SupabaseDataRow {
  TopReadArticlesRow(super.data);

  @override
  SupabaseTable get table => TopReadArticlesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get publisher => getField<String>('publisher');
  set publisher(String? value) => setField<String>('publisher', value);

  String? get publisherImageUrl => getField<String>('publisherImageUrl');
  set publisherImageUrl(String? value) =>
      setField<String>('publisherImageUrl', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get tag => getField<String>('tag');
  set tag(String? value) => setField<String>('tag', value);

  String? get newsDescription => getField<String>('newsDescription');
  set newsDescription(String? value) =>
      setField<String>('newsDescription', value);
}
