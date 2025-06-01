import '../database.dart';

class InvestementNewsArticlesTable
    extends SupabaseTable<InvestementNewsArticlesRow> {
  @override
  String get tableName => 'investementNewsArticles';

  @override
  InvestementNewsArticlesRow createRow(Map<String, dynamic> data) =>
      InvestementNewsArticlesRow(data);
}

class InvestementNewsArticlesRow extends SupabaseDataRow {
  InvestementNewsArticlesRow(super.data);

  @override
  SupabaseTable get table => InvestementNewsArticlesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get tag => getField<String>('tag');
  set tag(String? value) => setField<String>('tag', value);

  String? get newsDescription => getField<String>('newsDescription');
  set newsDescription(String? value) =>
      setField<String>('newsDescription', value);

  String? get publisher => getField<String>('publisher');
  set publisher(String? value) => setField<String>('publisher', value);

  String? get publisherImageUrl => getField<String>('publisherImageUrl');
  set publisherImageUrl(String? value) =>
      setField<String>('publisherImageUrl', value);
}
