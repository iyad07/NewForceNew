import '../database.dart';

class EditorrecommendationTable extends SupabaseTable<EditorrecommendationRow> {
  @override
  String get tableName => 'editorrecommendation';

  @override
  EditorrecommendationRow createRow(Map<String, dynamic> data) =>
      EditorrecommendationRow(data);
}

class EditorrecommendationRow extends SupabaseDataRow {
  EditorrecommendationRow(super.data);

  @override
  SupabaseTable get table => EditorrecommendationTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);
}
