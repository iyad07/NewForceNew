import '../database.dart';

class ConversationTable extends SupabaseTable<ConversationRow> {
  @override
  String get tableName => 'conversation';

  @override
  ConversationRow createRow(Map<String, dynamic> data) => ConversationRow(data);
}

class ConversationRow extends SupabaseDataRow {
  ConversationRow(super.data);

  @override
  SupabaseTable get table => ConversationTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  int? get chatId => getField<int>('chat_id');
  set chatId(int? value) => setField<int>('chat_id', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get content => getField<String>('content');
  set content(String? value) => setField<String>('content', value);
}
