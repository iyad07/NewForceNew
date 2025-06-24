import '../database.dart';

class CommunityPostsTable extends SupabaseTable<CommunityPostsRow> {
  @override
  String get tableName => 'community_posts';

  @override
  CommunityPostsRow createRow(Map<String, dynamic> data) => CommunityPostsRow(data);
}

class CommunityPostsRow extends SupabaseDataRow {
  CommunityPostsRow(super.data);

  @override
  SupabaseTable get table => CommunityPostsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  int? get topicId => getField<int>('topic_id');
  set topicId(int? value) => setField<int>('topic_id', value);

  String? get content => getField<String>('content');
  set content(String? value) => setField<String>('content', value);

  int? get likesCount => getField<int>('likes_count');
  set likesCount(int? value) => setField<int>('likes_count', value);

  int? get commentsCount => getField<int>('comments_count');
  set commentsCount(int? value) => setField<int>('comments_count', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  String? get userName => getField<String>('user_name');
  set userName(String? value) => setField<String>('user_name', value);

  String? get userAvatar => getField<String>('user_avatar');
  set userAvatar(String? value) => setField<String>('user_avatar', value);
}