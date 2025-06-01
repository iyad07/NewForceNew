import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'donate_card_model.dart';
export 'donate_card_model.dart';

class DonateCardWidget extends StatefulWidget {
  const DonateCardWidget({super.key});

  @override
  State<DonateCardWidget> createState() => _DonateCardWidgetState();
}

class _DonateCardWidgetState extends State<DonateCardWidget>
    with TickerProviderStateMixin {
  late DonateCardModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DonateCardModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
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
            duration: 600.0.ms,
            begin: const Offset(0.0, 90.0),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.9,
        height: MediaQuery.sizeOf(context).height * 0.588,
        constraints: const BoxConstraints(
          maxWidth: 500.0,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 12.0, 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Save Ghana Fund',
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'SFPro',
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
              ),
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 4.0),
                  child: Text(
                    '#SAVEGHANAFUND is a project/initiative aimed at reinvigorating the political climate with fresh perspectives, integrity, and progressive ideals. \n\nOur goal is to challenge traditional paradigms, promote transparency, and prioritize the needs of all Ghanaian citizens, regardless of background or status.\n\nThrough grassroots efforts and inclusive governance, we seek to foster a political landscape where innovation thrives, accountability is paramount, and the common good guides every decision. \n\nTogether, we aspire to build a more responsive, empathetic, and resilient society for generations to come. Through the support of generous backers like yourself, we aim to challenge the status quo, champion innovative policies, and amplify the voices of underrepresented communities.',
                    style: FlutterFlowTheme.of(context).labelSmall.override(
                          fontFamily: 'SFPro',
                          fontSize: 13.0,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                  ),
                ),
              ),
              Divider(
                height: 24.0,
                thickness: 2.0,
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 55.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    await launchURL(
                        'https://donate.changoapp.com/group/28226D98-9383-4F28-A410-0BF1B5814851/campaign/6633b4b2a6054');
                  },
                  text: 'Donate',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 45.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'SFPro',
                          color: Colors.white,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                    elevation: 3.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
    );
  }
}
