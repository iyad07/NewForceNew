import '../database.dart';

class ShortVideosTable extends SupabaseTable<ShortVideosRow> {
  @override
  String get tableName => 'shortVideos';

  @override
  ShortVideosRow createRow(Map<String, dynamic> data) => ShortVideosRow(data);
}

class ShortVideosRow extends SupabaseDataRow {
  ShortVideosRow(super.data);

  @override
  SupabaseTable get table => ShortVideosTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get videoUrl => getField<String>('videoUrl');
  set videoUrl(String? value) => setField<String>('videoUrl', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get thumbnailUrl => getField<String>('thumbnailUrl');
  set thumbnailUrl(String? value) => setField<String>('thumbnailUrl', value);
}
