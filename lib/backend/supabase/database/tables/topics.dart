import '../database.dart';

class TopicsTable extends SupabaseTable<TopicsRow> {
  @override
  String get tableName => 'topics';

  @override
  TopicsRow createRow(Map<String, dynamic> data) => TopicsRow(data);
}

class TopicsRow extends SupabaseDataRow {
  TopicsRow(super.data);

  @override
  SupabaseTable get table => TopicsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  int? get postsCount => getField<int>('posts_count');
  set postsCount(int? value) => setField<int>('posts_count', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);
}