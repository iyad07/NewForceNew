import '../database.dart';

class NewForceArticlesTable extends SupabaseTable<NewForceArticlesRow> {
  @override
  String get tableName => 'newForceArticles';

  @override
  NewForceArticlesRow createRow(Map<String, dynamic> data) =>
      NewForceArticlesRow(data);
}

class NewForceArticlesRow extends SupabaseDataRow {
  NewForceArticlesRow(super.data);

  @override
  SupabaseTable get table => NewForceArticlesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get publishers => getField<String>('publishers');
  set publishers(String? value) => setField<String>('publishers', value);

  String? get articleUrl => getField<String>('articleUrl');
  set articleUrl(String? value) => setField<String>('articleUrl', value);

  String? get articeImage => getField<String>('articeImage');
  set articeImage(String? value) => setField<String>('articeImage', value);

  String? get articleBody => getField<String>('articleBody');
  set articleBody(String? value) => setField<String>('articleBody', value);

  String? get urlLink => getField<String>('urlLink');
  set urlLink(String? value) => setField<String>('urlLink', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);
}
