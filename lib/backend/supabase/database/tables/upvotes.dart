import '../database.dart';

class UpvotesTable extends SupabaseTable<UpvotesRow> {
  @override
  String get tableName => 'upvotes';

  @override
  UpvotesRow createRow(Map<String, dynamic> data) => UpvotesRow(data);
}

class UpvotesRow extends SupabaseDataRow {
  UpvotesRow(super.data);

  @override
  SupabaseTable get table => UpvotesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  bool? get trueField => getField<bool>('true');
  set trueField(bool? value) => setField<bool>('true', value);

  String? get user => getField<String>('user');
  set user(String? value) => setField<String>('user', value);
}
