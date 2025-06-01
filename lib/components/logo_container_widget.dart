import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'logo_container_model.dart';
export 'logo_container_model.dart';

class LogoContainerWidget extends StatefulWidget {
  const LogoContainerWidget({super.key});

  @override
  State<LogoContainerWidget> createState() => _LogoContainerWidgetState();
}

class _LogoContainerWidgetState extends State<LogoContainerWidget>
    with TickerProviderStateMixin {
  late LogoContainerModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LogoContainerModel());

    animationsMap.addAll({
      'textOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
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
            begin: const Offset(0.0, 6.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      width: double.infinity,
      height: 80.0,
      decoration: const BoxDecoration(),
      child: MouseRegion(
        opaque: false,
        cursor: MouseCursor.defer ?? MouseCursor.defer,
        onEnter: ((event) async {
          safeSetState(() => _model.mouseRegionHovered = true);
          if (animationsMap['textOnActionTriggerAnimation'] != null) {
            await animationsMap['textOnActionTriggerAnimation']!
                .controller
                .forward(from: 0.0);
          }
        }),
        onExit: ((event) async {
          safeSetState(() => _model.mouseRegionHovered = false);
          if (animationsMap['textOnActionTriggerAnimation'] != null) {
            await animationsMap['textOnActionTriggerAnimation']!
                .controller
                .reverse();
          }
        }),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                if (FFAppState().isDarkMode == true) {
                  setDarkModeSetting(context, ThemeMode.light);
                } else {
                  setDarkModeSetting(context, ThemeMode.dark);
                }

                FFAppState().isDarkMode = false;
                safeSetState(() {});
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/2c3MyMG6yIofkkulvyLX3I23d8t_(2).png',
                  width: 100.0,
                  height: 60.0,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    await launchURL('https://www.thedigitalpro.co.uk');
                  },
                  child: Text(
                    'www.nkb.com.gh',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Tiro Bangla',
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ).animateOnActionTrigger(
                  animationsMap['textOnActionTriggerAnimation']!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
