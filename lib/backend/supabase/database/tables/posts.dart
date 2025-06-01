import '../database.dart';

class PostsTable extends SupabaseTable<PostsRow> {
  @override
  String get tableName => 'posts';

  @override
  PostsRow createRow(Map<String, dynamic> data) => PostsRow(data);
}

class PostsRow extends SupabaseDataRow {
  PostsRow(super.data);

  @override
  SupabaseTable get table => PostsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get postImageUrl => getField<String>('postImageUrl');
  set postImageUrl(String? value) => setField<String>('postImageUrl', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get user => getField<String>('user');
  set user(String? value) => setField<String>('user', value);

  int? get upvotes => getField<int>('upvotes');
  set upvotes(int? value) => setField<int>('upvotes', value);

  int? get comments => getField<int>('comments');
  set comments(int? value) => setField<int>('comments', value);
}
