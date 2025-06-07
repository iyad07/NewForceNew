import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'game_model.dart';
export 'game_model.dart';

class GameWidget extends StatefulWidget {
  const GameWidget({super.key});

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> with TickerProviderStateMixin {
  late GameModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GameModel());
    _initializeAnimations();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    animationsMap.addAll({
      'rowOnPageLoadAnimation': _createFadeAnimation(1370.0, 1510.0),
      'containerOnPageLoadAnimation1': _createWelcomeAnimation(),
      'containerOnPageLoadAnimation2': _createStartButtonAnimation(),
      'textOnPageLoadAnimation1': _createStartTextAnimation(),
      'containerOnPageLoadAnimation3': _createLevelAnimation(-55.0, 240.0, 1630.0),
      'textOnPageLoadAnimation2': _createTextAnimation(-55.0, 240.0, 1630.0),
      'containerOnPageLoadAnimation4': _createLevelAnimation(-44.0, 300.0, 1620.0),
      'textOnPageLoadAnimation3': _createTextAnimation(-44.0, 300.0, 1620.0),
      'containerOnPageLoadAnimation5': _createLevelAnimation(-44.0, 360.0, 1640.0),
      'textOnPageLoadAnimation4': _createTextAnimation(-44.0, 360.0, 1640.0),
      'containerOnPageLoadAnimation6': _createLevelAnimation(-44.0, 360.0, 1640.0),
      'textOnPageLoadAnimation5': _createTextAnimation(-44.0, 360.0, 1640.0),
      'containerOnPageLoadAnimation7': _createLevelAnimation(-44.0, 300.0, 1620.0),
      'textOnPageLoadAnimation6': _createTextAnimation(-44.0, 300.0, 1620.0),
      'containerOnPageLoadAnimation8': _createLevelAnimation(-55.0, 240.0, 1630.0),
      'textOnPageLoadAnimation7': _createTextAnimation(-55.0, 240.0, 1630.0),
      'containerOnPageLoadAnimation9': _createLevelAnimation(-55.0, 240.0, 1630.0),
      'textOnPageLoadAnimation8': _createTextAnimation(-55.0, 240.0, 1630.0),
    });
  }

  AnimationInfo _createFadeAnimation(double delay, double duration) {
    return AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effectsBuilder: () => [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: delay.ms,
          duration: duration.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    );
  }

  AnimationInfo _createWelcomeAnimation() {
    return AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effectsBuilder: () => [
        VisibilityEffect(duration: 2000.ms),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 2000.0.ms,
          duration: 1790.0.ms,
          begin: const Offset(-1.0, 0.0),
          end: const Offset(0.0, 0.0),
        ),
      ],
    );
  }

  AnimationInfo _createStartButtonAnimation() {
    return AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effectsBuilder: () => [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 600.0.ms,
          duration: 600.0.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 180.0.ms,
          duration: 1660.0.ms,
          begin: const Offset(-74.0, 0.0),
          end: const Offset(0.0, 0.0),
        ),
        TintEffect(
          curve: Curves.easeInOut,
          delay: 1130.0.ms,
          duration: 600.0.ms,
          color: const Color(0xFF00F71B),
          begin: 0.0,
          end: 0.65,
        ),
      ],
    );
  }

  AnimationInfo _createStartTextAnimation() {
    return AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effectsBuilder: () => [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 600.0.ms,
          duration: 600.0.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 180.0.ms,
          duration: 1660.0.ms,
          begin: const Offset(-74.0, 0.0),
          end: const Offset(0.0, 0.0),
        ),
        TintEffect(
          curve: Curves.easeInOut,
          delay: 1130.0.ms,
          duration: 600.0.ms,
          color: Colors.black,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    );
  }

  AnimationInfo _createLevelAnimation(double offsetX, double moveDelay, double moveDuration) {
    return AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effectsBuilder: () => [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 600.0.ms,
          duration: 600.0.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: moveDelay.ms,
          duration: moveDuration.ms,
          begin: Offset(offsetX, 0.0),
          end: const Offset(0.0, 0.0),
        ),
      ],
    );
  }

  AnimationInfo _createTextAnimation(double offsetX, double moveDelay, double moveDuration) {
    return AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effectsBuilder: () => [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 600.0.ms,
          duration: 600.0.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: moveDelay.ms,
          duration: moveDuration.ms,
          begin: Offset(offsetX, 0.0),
          end: const Offset(0.0, 0.0),
        ),
      ],
    );
  }

  Widget _buildTopMenu() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 12.0),
      height: 65.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        children: [
          Expanded(child: _buildLifePointsSection()),
          _buildMenuDivider(),
          Expanded(child: _buildLeaderBoardSection()),
          _buildMenuDivider(),
          Expanded(child: _buildDailyChallengeSection()),
        ],
      ),
    );
  }

  Widget _buildLifePointsSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 30.0,
          icon: Icon(
            FFIcons.kflash,
            color: FlutterFlowTheme.of(context).primary,
            size: 20.0,
          ),
          onPressed: () => print('IconButton pressed ...'),
        ),
        Text(
          'Life Points',
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Tiro Bangla',
            fontSize: 8.0,
            letterSpacing: 0.0,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildLeaderBoardSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          FFIcons.kcup,
          color: FlutterFlowTheme.of(context).primary,
          size: 20.0,
        ),
        Text(
          'LeaderBoard',
          style: FlutterFlowTheme.of(context).labelLarge.override(
            fontFamily: 'SFPro',
            color: FlutterFlowTheme.of(context).secondary,
            fontSize: 10.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.normal,
            useGoogleFonts: false,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDailyChallengeSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          FFIcons.kcalendarEdit,
          color: FlutterFlowTheme.of(context).primary,
          size: 20.0,
        ),
        Text(
          'Daily Challenge',
          style: FlutterFlowTheme.of(context).labelLarge.override(
            fontFamily: 'SFPro',
            color: FlutterFlowTheme.of(context).secondary,
            fontSize: 10.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.normal,
            useGoogleFonts: false,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildMenuDivider() {
    return Icon(
      Icons.chevron_right_rounded,
      color: FlutterFlowTheme.of(context).accent1,
      size: 14.0,
    );
  }

  Widget _buildWelcomeRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/images/ForceGIFanimation-unscreen.gif',
              width: 117.0,
              height: 118.0,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Container(
              height: 72.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FlutterFlowTheme.of(context).secondaryBackground,
                    const Color(0x21DA6F00)
                  ],
                  stops: const [0.0, 1.0],
                  begin: const AlignmentDirectional(0.0, -1.0),
                  end: const AlignmentDirectional(0, 1.0),
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(0.0),
                  bottomRight: Radius.circular(15.0),
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 5.0, 20.0, 12.0),
                  child: Text(
                    'Welcome to the New Force Trivia',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'SFPro',
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                  ),
                ),
              ),
            ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
          ),
        ],
      ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation']!),
    );
  }

  Widget _buildLevelButton({
    required int level,
    required String containerAnimation,
    required String textAnimation,
    required EdgeInsets padding,
    bool isStartButton = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeIn,
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: [
                  BoxShadow(
                    blurRadius: isStartButton ? 5.0 : 4.0,
                    color: isStartButton
                        ? FlutterFlowTheme.of(context).tertiary
                        : FlutterFlowTheme.of(context).primary,
                    offset: Offset(0.0, isStartButton ? 2.0 : 1.5),
                    spreadRadius: isStartButton ? 3.0 : 0.0,
                  )
                ],
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: isStartButton
                    ? Center(
                        child: Text(
                          'Start',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Tiro Bangla',
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Icon(
                        FFIcons.klock,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 44.0,
                      ),
              ),
            ),
          ).animateOnPageLoad(animationsMap[containerAnimation]!),
          const SizedBox(height: 10.0),
          Text(
            'Level $level',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Tiro Bangla',
              letterSpacing: 0.0,
            ),
          ).animateOnPageLoad(animationsMap[textAnimation]!),
        ],
      ),
    );
  }

  Widget _buildGameLevels() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLevelButton(
              level: 1,
              containerAnimation: 'containerOnPageLoadAnimation2',
              textAnimation: 'textOnPageLoadAnimation1',
              padding: const EdgeInsets.fromLTRB(180.0, 0.0, 0.0, 20.0),
              isStartButton: true,
              onTap: () => context.pushNamed('quizquestions'),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLevelButton(
              level: 2,
              containerAnimation: 'containerOnPageLoadAnimation3',
              textAnimation: 'textOnPageLoadAnimation2',
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 60.0, 20.0),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLevelButton(
              level: 3,
              containerAnimation: 'containerOnPageLoadAnimation4',
              textAnimation: 'textOnPageLoadAnimation3',
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 80.0, 20.0),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLevelButton(
              level: 4,
              containerAnimation: 'containerOnPageLoadAnimation5',
              textAnimation: 'textOnPageLoadAnimation4',
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 190.0, 20.0),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLevelButton(
              level: 5,
              containerAnimation: 'containerOnPageLoadAnimation6',
              textAnimation: 'textOnPageLoadAnimation5',
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 190.0, 20.0),
            ),
          ],
        ),
        Divider(
          thickness: 1.0,
          color: FlutterFlowTheme.of(context).primary,
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLevelButton(
              level: 6,
              containerAnimation: 'containerOnPageLoadAnimation7',
              textAnimation: 'textOnPageLoadAnimation6',
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 80.0, 20.0),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLevelButton(
              level: 7,
              containerAnimation: 'containerOnPageLoadAnimation8',
              textAnimation: 'textOnPageLoadAnimation7',
              padding: const EdgeInsets.fromLTRB(110.0, 0.0, 60.0, 20.0),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLevelButton(
              level: 8,
              containerAnimation: 'containerOnPageLoadAnimation9',
              textAnimation: 'textOnPageLoadAnimation8',
              padding: const EdgeInsets.fromLTRB(220.0, 0.0, 60.0, 20.0),
            ),
          ],
        ),
      ],
    );
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
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.network(
                  'https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExZmVpa3FtY29vOXhpcXU5c2FtN2ppcmFjN3p5eGNvMXV1cWc4YTU4MyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/RHIKETUlUINYvV7CAO/giphy.webp',
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTopMenu(),
                  _buildWelcomeRow(),
                  _buildGameLevels(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}