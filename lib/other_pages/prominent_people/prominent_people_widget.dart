import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'prominent_people_model.dart';
import 'prominent_person_detail_widget.dart';
export 'prominent_people_model.dart';

class ProminentPeopleWidget extends StatefulWidget {
  const ProminentPeopleWidget({super.key});

  @override
  State<ProminentPeopleWidget> createState() => _ProminentPeopleWidgetState();
}

class _ProminentPeopleWidgetState extends State<ProminentPeopleWidget> {
  late ProminentPeopleModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProminentPeopleModel());
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
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Prominent People',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'SF Pro Display',
              color: Colors.white,
              fontSize: 22.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.bold,
              useGoogleFonts: false,
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 20.0, 20.0, 20.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FlutterFlowTheme.of(context).primary,
                        FlutterFlowTheme.of(context).secondary,
                      ],
                      stops: [0.0, 1.0],
                      begin: AlignmentDirectional(-1.0, -1.0),
                      end: AlignmentDirectional(1.0, 1.0),
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.stars_rounded,
                        color: Colors.white,
                        size: 48.0,
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        'Influential Figures',
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'SF Pro Display',
                          color: Colors.white,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: false,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Discover the stories of remarkable individuals who have shaped our world',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'SF Pro Display',
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                
                // People List
                Expanded(
                  child: FutureBuilder<List<CountryInfluencialProfilesRow>>(
                    future: CountryInfluencialProfilesTable().queryRows(
                      queryFn: (q) => q.order('created_at'),
                    ),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: SpinKitFadingCircle(
                              color: FlutterFlowTheme.of(context).primary,
                              size: 50.0,
                            ),
                          ),
                        );
                      }
                      List<CountryInfluencialProfilesRow> listViewCountryInfluencialProfilesRowList =
                          snapshot.data!;

                      if (listViewCountryInfluencialProfilesRowList.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 64.0,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                'No prominent people found',
                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'SF Pro Display',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: listViewCountryInfluencialProfilesRowList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                        itemBuilder: (context, listViewIndex) {
                          final listViewCountryInfluencialProfilesRow =
                              listViewCountryInfluencialProfilesRowList[listViewIndex];
                          return _buildPersonCard(listViewCountryInfluencialProfilesRow);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPersonCard(CountryInfluencialProfilesRow person) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProminentPersonDetailWidget(
              person: person,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0.0, 4.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 2.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: person.image != null && person.image!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: person.image!,
                          width: 80.0,
                          height: 80.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 80.0,
                            height: 80.0,
                            color: FlutterFlowTheme.of(context).alternate,
                            child: Icon(
                              Icons.person,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 40.0,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 80.0,
                            height: 80.0,
                            color: FlutterFlowTheme.of(context).alternate,
                            child: Icon(
                              Icons.person,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 40.0,
                            ),
                          ),
                        )
                      : Container(
                          width: 80.0,
                          height: 80.0,
                          color: FlutterFlowTheme.of(context).alternate,
                          child: Icon(
                            Icons.person,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 40.0,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16.0),
              
              // Person Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      person.name ?? 'Unknown',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                        fontFamily: 'SF Pro Display',
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                        useGoogleFonts: false,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    
                    // Profession
                    if (person.profession != null && person.profession!.isNotEmpty) ...[
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(
                            Icons.work_outline,
                            size: 16.0,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              person.profession!,
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'SF Pro Display',
                                color: FlutterFlowTheme.of(context).primary,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    // Nationality
                    if (person.nationality != null && person.nationality!.isNotEmpty) ...[
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16.0,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            person.nationality!,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'SF Pro Display',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    if (person.networth != null && person.networth!.isNotEmpty) ...[
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 16.0,
                            color: FlutterFlowTheme.of(context).secondary,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            'Net Worth: ${person.networth!}',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'SF Pro Display',
                              color: FlutterFlowTheme.of(context).secondary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    if (person.bio != null && person.bio!.isNotEmpty) ...[
                      const SizedBox(height: 8.0),
                      Text(
                        person.bio!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'SF Pro Display',
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}