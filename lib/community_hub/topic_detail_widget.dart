import '../auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';


class TopicDetailWidget extends StatefulWidget {
  const TopicDetailWidget({
    super.key,
    required this.topicId,
    required this.topicTitle,
  });

  final int? topicId;
  final String? topicTitle;

  @override
  State<TopicDetailWidget> createState() => _TopicDetailWidgetState();
}

class _TopicDetailWidgetState extends State<TopicDetailWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _postController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            widget.topicTitle ?? 'Topic',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'SF Pro Display',
              color: Colors.white,
              fontSize: 22.0,
              letterSpacing: 0.0,
              useGoogleFonts: false,
            ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 2.0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showCreatePostDialog();
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 28.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              _buildTopicOverview(),
              Expanded(
                child: _buildPostsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostsList() {
    return FutureBuilder<List<CommunityPostsRow>>(
      future: CommunityPostsTable().queryRows(
        queryFn: (q) => q
            .eq('topic_id', widget.topicId as Object)
            .order('created_at', ascending: false)
            .limit(50),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading posts',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'SF Pro Display',
                color: FlutterFlowTheme.of(context).error,
                useGoogleFonts: false,
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<CommunityPostsRow> posts = snapshot.data!;

        if (posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.forum_outlined,
                  size: 64.0,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'No posts yet',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'SF Pro Display',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    useGoogleFonts: false,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Be the first to share your thoughts!',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'SF Pro Display',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    useGoogleFonts: false,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: posts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16.0),
          itemBuilder: (context, index) {
            final post = posts[index];
            return _buildPostCard(post);
          },
        );
      },
    );
  }

  Widget _buildPostCard(CommunityPostsRow post) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            blurRadius: 3.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 1.0),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info and timestamp
            Row(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: post.userAvatar != null && post.userAvatar!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.network(
                            post.userAvatar!,
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24.0,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 24.0,
                        ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName ?? 'Anonymous',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'SF Pro Display',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: false,
                        ),
                      ),
                      Text(
                        dateTimeFormat('relative', post.createdAt),
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'SF Pro Display',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12.0,
                          useGoogleFonts: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            // Post content
            Text(
              post.content ?? '',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'SF Pro Display',
                fontSize: 14.0,
                lineHeight: 1.5,
                useGoogleFonts: false,
              ),
            ),
            const SizedBox(height: 16.0),
            // Action buttons
            Row(
              children: [
                // Like button
                InkWell(
                  onTap: () => _likePost(post),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 20.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '${post.likesCount ?? 0}',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'SF Pro Display',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12.0,
                          useGoogleFonts: false,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24.0),
                // Comment button
                InkWell(
                  onTap: () => _showCommentsDialog(post),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 20.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '${post.commentsCount ?? 0}',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'SF Pro Display',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12.0,
                          useGoogleFonts: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Comment previews
            _buildCommentPreviews(post),
          ],
        ),
      ),
    );
  }

  Future<void> _likePost(CommunityPostsRow post) async {
    try {
      final newLikesCount = (post.likesCount ?? 0) + 1;
      await CommunityPostsTable().update(
        data: {
          'likes_count': newLikesCount,
        },
        matchingRows: (rows) => rows.eq('id', post.id),
      );

      setState(() {
        post.likesCount = newLikesCount;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Post liked!',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          duration: const Duration(milliseconds: 1000),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error liking post: $e',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          duration: const Duration(milliseconds: 2000),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Create Post',
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontFamily: 'SF Pro Display',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: false,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    // User info
                    Row(
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: currentUserPhoto.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.network(
                                    currentUserPhoto,
                                    width: 40.0,
                                    height: 40.0,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 24.0,
                                      );
                                    },
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                        ),
                        const SizedBox(width: 12.0),
                        Text(
                          currentUserDisplayName ?? 'Anonymous',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'SF Pro Display',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    // Text input
                    TextFormField(
                      controller: _postController,
                      decoration: InputDecoration(
                        hintText: 'What\'s on your mind?',
                        hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'SF Pro Display',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          useGoogleFonts: false,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'SF Pro Display',
                        useGoogleFonts: false,
                      ),
                      maxLines: 5,
                      minLines: 3,
                    ),
                    const SizedBox(height: 20.0),
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _postController.clear();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'SF Pro Display',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              useGoogleFonts: false,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_postController.text.trim().isNotEmpty) {
                              try {
                                await CommunityPostsTable().insert({
                                  'user_id': currentUserUid,
                                  'topic_id': widget.topicId,
                                  'content': _postController.text.trim(),
                                  'user_name': currentUserDisplayName ?? 'Anonymous',
                                  'user_avatar': currentUserPhoto,
                                  'likes_count': 0,
                                  'comments_count': 0,
                                });
                                
                                _postController.clear();
                                Navigator.of(context).pop();
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Post created successfully!',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context).primaryText,
                                      ),
                                    ),
                                    duration: const Duration(milliseconds: 2000),
                                    backgroundColor: FlutterFlowTheme.of(context).secondary,
                                  ),
                                );
                                
                                setState(() {});
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error creating post: $e',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context).primaryText,
                                      ),
                                    ),
                                    duration: const Duration(milliseconds: 4000),
                                    backgroundColor: FlutterFlowTheme.of(context).error,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: FlutterFlowTheme.of(context).primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Post',
                            style: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'SF Pro Display',
                              color: Colors.white,
                              useGoogleFonts: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCommentsDialog(CommunityPostsRow post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Comments',
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontFamily: 'SF Pro Display',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: false,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const Divider(),
                    // Comments list
                    Expanded(
                      child: _buildCommentsList(post),
                    ),
                    const Divider(),
                    // Add comment section
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'SF Pro Display',
                                color: FlutterFlowTheme.of(context).secondaryText,
                                useGoogleFonts: false,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'SF Pro Display',
                              useGoogleFonts: false,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        IconButton(
                          onPressed: () async {
                            if (_commentController.text.trim().isNotEmpty) {
                              await _addComment(post, _commentController.text.trim());
                              _commentController.clear();
                              setDialogState(() {}); // Refresh dialog state
                            }
                          },
                          icon: Icon(
                            Icons.send,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCommentsList(CommunityPostsRow post) {
    return FutureBuilder<List<PostCommentsRow>>(
      future: PostCommentsTable().queryRows(
        queryFn: (q) => q
            .eq('post_id', post.id)
            .order('created_at', ascending: true)
            .limit(100),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading comments',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'SF Pro Display',
                color: FlutterFlowTheme.of(context).error,
                useGoogleFonts: false,
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<PostCommentsRow> comments = snapshot.data!;

        if (comments.isEmpty) {
          return Center(
            child: Text(
              'No comments yet. Be the first to comment!',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'SF Pro Display',
                color: FlutterFlowTheme.of(context).secondaryText,
                useGoogleFonts: false,
              ),
            ),
          );
        }

        return ListView.separated(
          itemCount: comments.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12.0),
          itemBuilder: (context, index) {
            final comment = comments[index];
            return _buildCommentCard(comment);
          },
        );
      },
    );
  }

  Widget _buildCommentCard(PostCommentsRow comment) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: comment.userAvatar != null && comment.userAvatar!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.network(
                          comment.userAvatar!,
                          width: 32.0,
                          height: 32.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 18.0,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 18.0,
                      ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName ?? 'Anonymous',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'SF Pro Display',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        useGoogleFonts: false,
                      ),
                    ),
                    Text(
                      dateTimeFormat('relative', comment.createdAt),
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'SF Pro Display',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 10.0,
                        useGoogleFonts: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            comment.content ?? '',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'SF Pro Display',
              fontSize: 13.0,
              useGoogleFonts: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentPreviews(CommunityPostsRow post) {
    if ((post.commentsCount ?? 0) == 0) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<List<PostCommentsRow>>(
      future: PostCommentsTable().queryRows(
        queryFn: (q) => q
            .eq('post_id', post.id)
            .order('created_at', ascending: false)
            .limit(2),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        List<PostCommentsRow> comments = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(top: 12.0),
          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 2.0,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: comments.map((comment) => _buildCommentPreview(comment)).toList(),
          ),
        );
      },
    );
  }

  Widget _buildCommentPreview(PostCommentsRow comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: comment.userAvatar != null && comment.userAvatar!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      comment.userAvatar!,
                      width: 24.0,
                      height: 24.0,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 14.0,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 14.0,
                  ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.userName ?? 'Anonymous',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'SF Pro Display',
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                        color: FlutterFlowTheme.of(context).primaryText,
                        useGoogleFonts: false,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '•',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'SF Pro Display',
                        fontSize: 11.0,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        useGoogleFonts: false,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      dateTimeFormat('relative', comment.createdAt),
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'SF Pro Display',
                        fontSize: 10.0,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        useGoogleFonts: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2.0),
                Text(
                  comment.content ?? '',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'SF Pro Display',
                    fontSize: 12.0,
                    color: FlutterFlowTheme.of(context).primaryText,
                    useGoogleFonts: false,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addComment(CommunityPostsRow post, String content) async {
    try {
      await PostCommentsTable().insert({
        'user_id': currentUserUid,
        'post_id': post.id,
        'content': content,
        'user_name': currentUserDisplayName ?? 'Anonymous',
        'user_avatar': currentUserPhoto,
      });

      // Update comment count
      final newCommentsCount = (post.commentsCount ?? 0) + 1;
      await CommunityPostsTable().update(
        data: {
          'comments_count': newCommentsCount,
        },
        matchingRows: (rows) => rows.eq('id', post.id),
      );

      // Update UI
      setState(() {
        post.commentsCount = newCommentsCount;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Comment added successfully!',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          duration: const Duration(milliseconds: 2000),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error adding comment: $e',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          duration: const Duration(milliseconds: 4000),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  Widget _buildTopicOverview() {
    return FutureBuilder<List<TopicsRow>>(
      future: TopicsTable().querySingleRow(
        queryFn: (q) => q.eq('id', widget.topicId as Object),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error loading topic details',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'SF Pro Display',
                color: FlutterFlowTheme.of(context).error,
                useGoogleFonts: false,
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: const Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            ),
          );
        }

        final topic = snapshot.data!.first;
        if (topic == null) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x2C7E5F1A), Color(0xFF201D1B)],
              stops: [0.0, 1.0],
              begin: AlignmentDirectional(0.59, -1.0),
              end: AlignmentDirectional(-0.59, 1.0),
            ),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: Color(0xFF3A3D41),
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Topic Header
                Row(
                  children: [
                    // Topic Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: topic.imageUrl != null && topic.imageUrl!.isNotEmpty
                          ? Image.network(
                              topic.imageUrl!,
                              width: 60.0,
                              height: 60.0,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF3A3D41),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Icon(
                                    Icons.forum,
                                    color: Color(0xFF6C7075),
                                    size: 30.0,
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: Color(0xFF3A3D41),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Icon(
                                Icons.forum,
                                color: Color(0xFF6C7075),
                                size: 30.0,
                              ),
                            ),
                    ),
                    const SizedBox(width: 16.0),
                    // Topic Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topic.title ?? 'Untitled Topic',
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  fontFamily: 'SF Pro Display',
                                  useGoogleFonts: false,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              Icon(
                                Icons.people_rounded,
                                color: Color(0xFF6C7075),
                                size: 16.0,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                '${topic.postsCount ?? 0} posts',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'SF Pro Display',
                                      useGoogleFonts: false,
                                      color: Color(0xFF6C7075),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              const SizedBox(width: 16.0),
                              Icon(
                                Icons.schedule_rounded,
                                color: Color(0xFF6C7075),
                                size: 16.0,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                _formatDate(topic.createdAt),
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'SF Pro Display',
                                      useGoogleFonts: false,
                                      color: Color(0xFF6C7075),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Topic Description
                if (topic.description != null && topic.description!.isNotEmpty) ...[
                  const SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color(0x1A3A3D41),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Color(0x333A3D41),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      topic.description!,
                      style: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .override(
                            fontFamily: 'SF Pro Display',
                            useGoogleFonts: false,
                            color: Color(0xFFB0B3B8),
                            letterSpacing: 0.0,
                            lineHeight: 1.5,
                          ),
                    ),
                  ),
                ],
                // Topic Stats
                const SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Color(0x1AFF8000),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Color(0x33FF8000),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Color(0xFFFF8000),
                        size: 18.0,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'Join the discussion below',
                        style: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(
                              fontFamily: 'SF Pro Display',
                              useGoogleFonts: false,
                              color: Color(0xFFFF8000),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}