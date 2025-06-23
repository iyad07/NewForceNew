import '/backend/supabase/supabase.dart';
import '/components/writing_indicator_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'ai_chat_page_model.dart';
export 'ai_chat_page_model.dart';

class AiChatPageWidget extends StatefulWidget {
  const AiChatPageWidget({
    super.key,
    required this.id,
  });

  final int? id;

  @override
  State<AiChatPageWidget> createState() => _AiChatPageWidgetState();
}

class _AiChatPageWidgetState extends State<AiChatPageWidget>
    with TickerProviderStateMixin {
  late AiChatPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AiChatPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.chatResult = await ChatTable().queryRows(
        queryFn: (q) => q.eq(
          'id',
          widget.id as Object,
        ),
      );
      if ((_model.chatResult != null && (_model.chatResult)!.isNotEmpty) ==
          true) {
        _model.threadId = _model.chatResult?.first.threadId;
        _model.title = _model.chatResult!.first.title!;
        _model.titleTextController?.text = _model.title;
        safeSetState(() {});
      }
      _model.conversationResult = await ConversationTable().queryRows(
        queryFn: (q) => q
            .eq(
              'chat_id',
              widget.id as Object,
            )
            .order('created_at', ascending: true),
      );
      _model.conversation =
          _model.conversationResult!.toList().cast<ConversationRow>();
      safeSetState(() {});
      await Future.delayed(const Duration(milliseconds: 150));
      await _model.scrollingColumn?.animateTo(
        _model.scrollingColumn!.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.ease,
      );
    });

    _model.titleTextController ??= TextEditingController();
    _model.titleFocusNode ??= FocusNode();
    _model.promptTextFieldTextController ??= TextEditingController();
    _model.promptTextFieldFocusNode ??= FocusNode();

    animationsMap.addAll({
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, -6.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'iconButtonOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(-6.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 6.0),
            end: const Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'rowOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(-6.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'rowOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(6.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textFieldOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(-6.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'iconButtonOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(6.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.network(
                '',
              ).image,
            ),
            gradient: LinearGradient(
              colors: [
                FlutterFlowTheme.of(context).primaryBackground,
                FlutterFlowTheme.of(context).secondaryBackground
              ],
              stops: const [0.0, 1.0],
              begin: const AlignmentDirectional(0.0, -1.0),
              end: const AlignmentDirectional(0, 1.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 0.0, 0.0),
                                child: TextFormField(
                                  controller: _model.titleTextController,
                                  focusNode: _model.titleFocusNode,
                                  onFieldSubmitted: (value) async {
                                    if (value.trim().isNotEmpty) {
                                      await ChatTable().update(
                                        data: {
                                          'title': value.trim(),
                                        },
                                        matchingRows: (rows) => rows.eq('id', widget.id as Object),
                                      );
                                      _model.title = value.trim();
                                      safeSetState(() {});
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        fontFamily: 'SFPro',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                ).animateOnPageLoad(
                                    animationsMap['textOnPageLoadAnimation']!),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 30.0,
                        buttonSize: 40.0,
                        icon: FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 25.0,
                        ),
                        onPressed: () async {
                          context.safePop();
                        },
                      ).animateOnPageLoad(
                          animationsMap['iconButtonOnPageLoadAnimation1']!),
                    ].divide(const SizedBox(width: 12.0)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        6.0, 0.0, 6.0, 0.0),
                    child: SingleChildScrollView(
                      controller: _model.scrollingColumn,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  2.0, 0.0, 2.0, 0.0),
                              child: Builder(
                                builder: (context) {
                                  final conversationItem =
                                      _model.conversation.toList();

                                  return ListView.separated(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: conversationItem.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 8.0),
                                    itemBuilder:
                                        (context, conversationItemIndex) {
                                      final conversationItemItem =
                                          conversationItem[
                                              conversationItemIndex];
                                      return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          if ((int index) {
                                            return index % 2 != 0;
                                          }(conversationItemIndex))
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/GHFxnzlXkAAyjhw-removebg-preview_(1).png',
                                                      width: 45.0,
                                                      height: 45.0,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: () {
                                                          if (MediaQuery.sizeOf(
                                                                      context)
                                                                  .width >=
                                                              1170.0) {
                                                            return 700.0;
                                                          } else if (MediaQuery
                                                                      .sizeOf(
                                                                          context)
                                                                  .width <=
                                                              470.0) {
                                                            return 260.0;
                                                          } else {
                                                            return 530.0;
                                                          }
                                                        }(),
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  0.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  12.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  12.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  12.0),
                                                        ),
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(12.0,
                                                                8.0, 12.0, 8.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Builder(
                                                              builder:
                                                                  (context) {
                                                                if (conversationItemItem
                                                                            .content !=
                                                                        null &&
                                                                    conversationItemItem
                                                                            .content !=
                                                                        '') {
                                                                  return Container(
                                                                    decoration:
                                                                        const BoxDecoration(),
                                                                    child: custom_widgets
                                                                        .CustomMarkDown(
                                                                      width:
                                                                          0.0,
                                                                      height:
                                                                          0.0,
                                                                      inputString:
                                                                          conversationItemItem
                                                                              .content!,
                                                                    ),
                                                                  );
                                                                } else {
                                                                  return WritingIndicatorWidget(
                                                                    key: Key(
                                                                        'Keyjbl_${conversationItemIndex}_of_${conversationItem.length}'),
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ).animateOnPageLoad(animationsMap[
                                                'rowOnPageLoadAnimation1']!),
                                          if (conversationItemIndex % 2 == 0)
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth: () {
                                                      if (MediaQuery.sizeOf(
                                                                  context)
                                                              .width >=
                                                          1170.0) {
                                                        return 700.0;
                                                      } else if (MediaQuery
                                                                  .sizeOf(
                                                                      context)
                                                              .width <=
                                                          470.0) {
                                                        return 260.0;
                                                      } else {
                                                        return 530.0;
                                                      }
                                                    }(),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(12.0),
                                                      bottomRight:
                                                          Radius.circular(0.0),
                                                      topLeft:
                                                          Radius.circular(12.0),
                                                      topRight:
                                                          Radius.circular(12.0),
                                                    ),
                                                    border: Border.all(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent1,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 8.0,
                                                            12.0, 8.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          conversationItemItem
                                                              .content!,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Lato',
                                                                letterSpacing:
                                                                    0.0,
                                                                lineHeight: 1.4,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ).animateOnPageLoad(animationsMap[
                                                'rowOnPageLoadAnimation2']!),
                                        ].divide(const SizedBox(height: 8.0)),
                                      );
                                    },
                                    controller: _model.conversationListView,
                                  );
                                },
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation']!),
                        ].divide(const SizedBox(height: 12.0)),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  elevation: 6.0,
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _model.promptTextFieldTextController,
                            focusNode: _model.promptTextFieldFocusNode,
                            textInputAction: TextInputAction.send,
                            readOnly: _model.isLoading,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Tiro Bangla',
                                    letterSpacing: 0.0,
                                  ),
                              hintText: 'Type something ...',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'SFPro',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0x00000000),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Lato',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                            cursorColor: FlutterFlowTheme.of(context).primary,
                            validator: _model
                                .promptTextFieldTextControllerValidator
                                .asValidator(context),
                          ).animateOnPageLoad(
                              animationsMap['textFieldOnPageLoadAnimation']!),
                        ),
                        FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.send,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 25.0,
                          ),
                          showLoadingIndicator: true,
                          onPressed: () async {
                            _model.isLoading = !_model.isLoading;
                            safeSetState(() {});
                            // Add User Chat
                            _model.userConversationResult =
                                await ConversationTable().insert({
                              'chat_id': widget.id,
                              'type': 'USER',
                              'content':
                                  _model.promptTextFieldTextController.text,
                            });
                            // Add User Chat to History
                            _model.addToConversation(
                                _model.userConversationResult!);
                            safeSetState(() {});
                            // Add an empty System Chat
                            _model.latestSystemChatResult =
                                await ConversationTable().insert({
                              'chat_id': widget.id,
                              'type': 'SYSTEM',
                              'content': '',
                            });
                            // Add empoty chat to History
                            _model.addToConversation(
                                _model.latestSystemChatResult!);
                            safeSetState(() {});
                            await _model.scrollingColumn?.animateTo(
                              _model.scrollingColumn!.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.ease,
                            );
                            await actions.streamResponse(
                              () async {
                                safeSetState(() {});
                                _model.updateConversationAtIndex(
                                  _model.conversation.length - 1,
                                  (_) => functions.updateSystemSupabaseRow(
                                      _model.latestSystemChatResult!,
                                      FFAppState().streamResponse),
                                );
                                safeSetState(() {});
                                await _model.scrollingColumn?.animateTo(
                                  _model.scrollingColumn!.position
                                      .maxScrollExtent,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.ease,
                                );
                              },
                              (error) async {
                                _model.isLoading = false;
                                safeSetState(() {});
                              },
                              (threadId) async {
                                // Capture user message before clearing the text field
                                String userMessage = _model.userConversationResult?.content ?? '';
                                
                                safeSetState(() {
                                  _model.promptTextFieldTextController?.clear();
                                });
                                
                                // Update thread_id and auto-generate title if it's still default
                                Map<String, dynamic> updateData = {
                                  'thread_id': threadId,
                                };
                                
                                // Auto-generate title from first message if still using default
                                if (_model.title == 'Conversation' || _model.title.isEmpty) {
                                  String newTitle = userMessage.length > 50 
                                    ? '${userMessage.substring(0, 47)}...'
                                    : userMessage;
                                  updateData['title'] = newTitle;
                                  _model.title = newTitle;
                                  _model.titleTextController?.text = newTitle;
                                }
                                
                                await ChatTable().update(
                                  data: updateData,
                                  matchingRows: (rows) => rows.eq('id', widget.id as Object),
                                );
                                _model.threadId = threadId;
                                _model.isLoading = !_model.isLoading;
                                safeSetState(() {});
                                await ConversationTable().update(
                                  data: {
                                    'content': FFAppState().streamResponse,
                                  },
                                  matchingRows: (rows) => rows.eq('id', _model.latestSystemChatResult!.id),
                                );
                                FFAppState().streamResponse = '';
                                safeSetState(() {});
                                await _model.scrollingColumn?.animateTo(
                                  _model.scrollingColumn!.position
                                      .maxScrollExtent,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.ease,
                                );
                              },
                              'https://api.groq.com/openai/v1/chat/completions',
                              _model.promptTextFieldTextController.text,
                              _model.threadId,
                            );

                            safeSetState(() {});
                          },
                        ).animateOnPageLoad(
                            animationsMap['iconButtonOnPageLoadAnimation2']!),
                      ]
                          .divide(const SizedBox(width: 12.0))
                          .addToStart(const SizedBox(width: 24.0))
                          .addToEnd(const SizedBox(width: 24.0)),
                    ),
                  ),
                ),
              ]
                  .divide(const SizedBox(height: 24.0))
                  .addToStart(const SizedBox(height: 32.0))
                  .addToEnd(const SizedBox(height: 32.0)),
            ),
          ),
        ),
      ),
    );
  }
}
