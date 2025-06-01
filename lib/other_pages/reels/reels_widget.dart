import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import 'package:flutter/material.dart';
import 'reels_model.dart';
export 'reels_model.dart';

class ReelsWidget extends StatefulWidget {
  const ReelsWidget({super.key});

  @override
  State<ReelsWidget> createState() => _ReelsWidgetState();
}

class _ReelsWidgetState extends State<ReelsWidget> {
  late ReelsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReelsModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Stack(
            alignment: const AlignmentDirectional(0.0, 1.0),
            children: [
              Align(
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: FutureBuilder<List<ShortVideosRow>>(
                  future: FFAppState().reels(
                    requestFn: () => ShortVideosTable().queryRows(
                      queryFn: (q) => q.order('created_at', ascending: true),
                    ),
                  ),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Image.asset(
                        '',
                      );
                    }
                    List<ShortVideosRow> pageViewShortVideosRowList =
                        snapshot.data!;

                    return SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: PageView.builder(
                        controller: _model.pageViewController ??=
                            PageController(
                                initialPage: max(
                                    0,
                                    min(
                                        0,
                                        pageViewShortVideosRowList.length -
                                            1))),
                        scrollDirection: Axis.vertical,
                        itemCount: pageViewShortVideosRowList.length,
                        itemBuilder: (context, pageViewIndex) {
                          final pageViewShortVideosRow =
                              pageViewShortVideosRowList[pageViewIndex];
                          return Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Image.network(
                                      pageViewShortVideosRow.thumbnailUrl!,
                                    ).image,
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Image.network(
                                      pageViewShortVideosRow.thumbnailUrl!,
                                    ).image,
                                  ),
                                ),
                                child: FlutterFlowVideoPlayer(
                                  path: pageViewShortVideosRow.videoUrl!,
                                  videoType: VideoType.network,
                                  width: double.infinity,
                                  height: 100.0,
                                  autoPlay: true,
                                  looping: false,
                                  showControls: false,
                                  allowFullScreen: false,
                                  allowPlaybackSpeedMenu: false,
                                  lazyLoad: true,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
