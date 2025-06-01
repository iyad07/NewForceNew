import '/backend/supabase/supabase.dart';

ConversationRow updateSystemSupabaseRow(
  ConversationRow conversationRow,
  String content,
) {
  conversationRow.content = content;
  return conversationRow;
}
