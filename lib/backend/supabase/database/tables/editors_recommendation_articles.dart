import '../database.dart';

class EditorsRecommendationArticlesTable
    extends SupabaseTable<EditorsRecommendationArticlesRow> {
  @override
  String get tableName => 'editorsRecommendationArticles';

  @override
  EditorsRecommendationArticlesRow createRow(Map<String, dynamic> data) =>
      EditorsRecommendationArticlesRow(data);
}

class EditorsRecommendationArticlesRow extends SupabaseDataRow {
  EditorsRecommendationArticlesRow(super.data);

  @override
  SupabaseTable get table => EditorsRecommendationArticlesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get tag => getField<String>('tag');
  set tag(String? value) => setField<String>('tag', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get newsDescription => getField<String>('newsDescription');
  set newsDescription(String? value) =>
      setField<String>('newsDescription', value);

  String? get imageUrl => getField<String>('imageUrl');
  set imageUrl(String? value) => setField<String>('imageUrl', value);
}
