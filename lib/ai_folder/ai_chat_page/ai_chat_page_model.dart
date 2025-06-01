import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'ai_chat_page_widget.dart' show AiChatPageWidget;
import 'package:flutter/material.dart';

class AiChatPageModel extends FlutterFlowModel<AiChatPageWidget> {
  ///  Local state fields for this page.

  String? threadId;

  bool isLoading = false;

  List<ConversationRow> conversation = [];
  void addToConversation(ConversationRow item) => conversation.add(item);
  void removeFromConversation(ConversationRow item) =>
      conversation.remove(item);
  void removeAtIndexFromConversation(int index) => conversation.removeAt(index);
  void insertAtIndexInConversation(int index, ConversationRow item) =>
      conversation.insert(index, item);
  void updateConversationAtIndex(
          int index, Function(ConversationRow) updateFn) =>
      conversation[index] = updateFn(conversation[index]);

  String title = 'Title';

  bool recording = true;

  ConversationRow? latestSystemChat;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in aiChatPage widget.
  List<ChatRow>? chatResult;
  // Stores action output result for [Backend Call - Query Rows] action in aiChatPage widget.
  List<ConversationRow>? conversationResult;
  // State field(s) for ScrollingColumn widget.
  ScrollController? scrollingColumn;
  // State field(s) for ConversationListView widget.
  ScrollController? conversationListView;
  // State field(s) for PromptTextField widget.
  FocusNode? promptTextFieldFocusNode;
  TextEditingController? promptTextFieldTextController;
  String? Function(BuildContext, String?)?
      promptTextFieldTextControllerValidator;
  // Stores action output result for [Backend Call - Insert Row] action in SendIconButton widget.
  ConversationRow? userConversationResult;
  // Stores action output result for [Backend Call - Insert Row] action in SendIconButton widget.
  ConversationRow? latestSystemChatResult;

  @override
  void initState(BuildContext context) {
    scrollingColumn = ScrollController();
    conversationListView = ScrollController();
  }

  @override
  void dispose() {
    scrollingColumn?.dispose();
    conversationListView?.dispose();
    promptTextFieldFocusNode?.dispose();
    promptTextFieldTextController?.dispose();
  }
}
