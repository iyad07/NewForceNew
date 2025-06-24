import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
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

class _ProminentPeopleWidgetState extends State<ProminentPeopleWidget>
    with TickerProviderStateMixin {
  late ProminentPeopleModel _model;
  late TabController _tabController;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProminentPeopleModel());
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                margin: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
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
                      'Prominent People',
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
              const SizedBox(height: 16.0),
              
              // Tab Bar
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: FlutterFlowButtonTabBar(
                  useToggleButtonStyle: true,
                  labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'SF Pro Display',
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
                  unselectedLabelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'SF Pro Display',
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
                  labelColor: FlutterFlowTheme.of(context).primaryText,
                  unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
                  backgroundColor: FlutterFlowTheme.of(context).accent1,
                  unselectedBackgroundColor: FlutterFlowTheme.of(context).alternate,
                  borderColor: FlutterFlowTheme.of(context).primary,
                  unselectedBorderColor: FlutterFlowTheme.of(context).alternate,
                  borderWidth: 2.0,
                  borderRadius: 8.0,
                  elevation: 0.0,
                  buttonMargin: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                  padding: const EdgeInsets.all(4.0),
                  tabs: const [
                    Tab(
                      text: 'African Richest',
                    ),
                    Tab(
                      text: 'Influential Figures',
                    ),
                    Tab(
                      text: 'Success Stories',
                    ),
                  ],
                  controller: _tabController,
                  onTap: (i) async {
                    [() async {}, () async {}, () async {}][i]();
                  },
                ),
              ),
              
              // Tab Bar View
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAfricanRichestTab(),
                    _buildInfluentialFiguresTab(),
                    _buildSuccessStoriesTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildAfricanRichestTab() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
      child: FutureBuilder<List<AfricanRichestRow>>(
        future: AfricanRichestTable().queryRows(
          queryFn: (q) => q.order('id'),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading African richest people: ${snapshot.error}',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'SF Pro Display',
                  color: FlutterFlowTheme.of(context).error,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          
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
           
           List<AfricanRichestRow> listViewAfricanRichestRowList = snapshot.data!;
           if (listViewAfricanRichestRowList.isEmpty) {
             return Center(
               child: Text(
                 'No African richest people found.',
                 style: FlutterFlowTheme.of(context).bodyMedium.override(
                   fontFamily: 'SF Pro Display',
                   letterSpacing: 0.0,
                   useGoogleFonts: false,
                 ),
               ),
             );
           }
           
           return ListView.separated(
             padding: EdgeInsets.zero,
             scrollDirection: Axis.vertical,
             itemCount: listViewAfricanRichestRowList.length,
             separatorBuilder: (_, __) => const SizedBox(height: 12.0),
             itemBuilder: (context, listViewIndex) {
               final listViewAfricanRichestRow = listViewAfricanRichestRowList[listViewIndex];
               return _buildAfricanRichestCard(listViewAfricanRichestRow);
             },
           );
         },
       ),
     );
   }
   
   Widget _buildInfluentialFiguresTab() {
     return Padding(
       padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
       child: FutureBuilder<List<CountryInfluencialProfilesRow>>(
         future: CountryInfluencialProfilesTable().queryRows(
           queryFn: (q) => q.order('id'),
         ),
         builder: (context, snapshot) {
           if (snapshot.hasError) {
             return Center(
               child: Text(
                 'Error loading influential figures: ${snapshot.error}',
                 style: FlutterFlowTheme.of(context).bodyMedium.override(
                   fontFamily: 'SF Pro Display',
                   color: FlutterFlowTheme.of(context).error,
                   letterSpacing: 0.0,
                   useGoogleFonts: false,
                 ),
                 textAlign: TextAlign.center,
               ),
             );
           }
           
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
           
           List<CountryInfluencialProfilesRow> listViewCountryInfluencialProfilesRowList = snapshot.data!;
           if (listViewCountryInfluencialProfilesRowList.isEmpty) {
             return Center(
               child: Text(
                 'No prominent people found.',
                 style: FlutterFlowTheme.of(context).bodyMedium.override(
                   fontFamily: 'SF Pro Display',
                   letterSpacing: 0.0,
                   useGoogleFonts: false,
                 ),
               ),
             );
           }
           
           return ListView.separated(
             padding: EdgeInsets.zero,
             scrollDirection: Axis.vertical,
             itemCount: listViewCountryInfluencialProfilesRowList.length,
             separatorBuilder: (_, __) => const SizedBox(height: 12.0),
             itemBuilder: (context, listViewIndex) {
               final listViewCountryInfluencialProfilesRow = listViewCountryInfluencialProfilesRowList[listViewIndex];
               return _buildPersonCard(listViewCountryInfluencialProfilesRow);
             },
           );
         },
       ),
     );
   }
   
   Widget _buildSuccessStoriesTab() {
     return Padding(
       padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
       child: FutureBuilder<List<SuccessstoriesRow>>(
         future: SuccessstoriesTable().queryRows(
           queryFn: (q) => q.order('id'),
         ),
         builder: (context, snapshot) {
           if (snapshot.hasError) {
             return Center(
               child: Text(
                 'Error loading success stories: ${snapshot.error}',
                 style: FlutterFlowTheme.of(context).bodyMedium.override(
                   fontFamily: 'SF Pro Display',
                   color: FlutterFlowTheme.of(context).error,
                   letterSpacing: 0.0,
                   useGoogleFonts: false,
                 ),
                 textAlign: TextAlign.center,
               ),
             );
           }
           
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
           
           List<SuccessstoriesRow> listViewSuccessstoriesRowList = snapshot.data!;
           if (listViewSuccessstoriesRowList.isEmpty) {
             return Center(
               child: Text(
                 'No success stories found.',
                 style: FlutterFlowTheme.of(context).bodyMedium.override(
                   fontFamily: 'SF Pro Display',
                   letterSpacing: 0.0,
                   useGoogleFonts: false,
                 ),
               ),
             );
           }
           
           return ListView.separated(
             padding: EdgeInsets.zero,
             scrollDirection: Axis.vertical,
             itemCount: listViewSuccessstoriesRowList.length,
             separatorBuilder: (_, __) => const SizedBox(height: 12.0),
             itemBuilder: (context, listViewIndex) {
               final listViewSuccessstoriesRow = listViewSuccessstoriesRowList[listViewIndex];
               return _buildSuccessStoryCard(listViewSuccessstoriesRow);
             },
           );
         },
       ),
     );
   }
   
   Widget _buildAfricanRichestCard(AfricanRichestRow person) {
     return Container(
       width: double.infinity,
       decoration: BoxDecoration(
         color: FlutterFlowTheme.of(context).secondaryBackground,
         borderRadius: BorderRadius.circular(16.0),
         border: Border.all(
           color: FlutterFlowTheme.of(context).alternate,
           width: 1.0,
         ),
       ),
       child: Padding(
         padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
         child: Row(
           mainAxisSize: MainAxisSize.max,
           children: [
             // Profile Image
             Container(
               width: 60.0,
               height: 60.0,
               decoration: BoxDecoration(
                 color: FlutterFlowTheme.of(context).accent1,
                 borderRadius: BorderRadius.circular(30.0),
                 border: Border.all(
                   color: FlutterFlowTheme.of(context).primary,
                   width: 2.0,
                 ),
               ),
               child: ClipRRect(
                 borderRadius: BorderRadius.circular(30.0),
                 child: person.pics != null && person.pics!.isNotEmpty
                     ? Image.network(
                         person.pics!,
                         width: 60.0,
                         height: 60.0,
                         fit: BoxFit.cover,
                         errorBuilder: (context, error, stackTrace) {
                           return Container(
                             width: 60.0,
                             height: 60.0,
                             decoration: BoxDecoration(
                               color: FlutterFlowTheme.of(context).accent1,
                               borderRadius: BorderRadius.circular(30.0),
                             ),
                             child: Icon(
                               Icons.person,
                               color: FlutterFlowTheme.of(context).primary,
                               size: 30.0,
                             ),
                           );
                         },
                       )
                     : Container(
                         width: 60.0,
                         height: 60.0,
                         decoration: BoxDecoration(
                           color: FlutterFlowTheme.of(context).accent1,
                           borderRadius: BorderRadius.circular(30.0),
                         ),
                         child: Icon(
                           Icons.person,
                           color: FlutterFlowTheme.of(context).primary,
                           size: 30.0,
                         ),
                       ),
               ),
             ),
             const SizedBox(width: 16.0),
             
             // Person Details
             Expanded(
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     person.name ?? 'Unknown',
                     style: FlutterFlowTheme.of(context).bodyLarge.override(
                       fontFamily: 'SF Pro Display',
                       letterSpacing: 0.0,
                       fontWeight: FontWeight.w600,
                       useGoogleFonts: false,
                     ),
                   ),
                   const SizedBox(height: 4.0),
                   Text(
                     'Net Worth: ${person.networth ?? 'N/A'}',
                     style: FlutterFlowTheme.of(context).bodyMedium.override(
                       fontFamily: 'SF Pro Display',
                       color: FlutterFlowTheme.of(context).primary,
                       letterSpacing: 0.0,
                       fontWeight: FontWeight.w500,
                       useGoogleFonts: false,
                     ),
                   ),
                   const SizedBox(height: 4.0),
                   Text(
                     'Age: ${person.age?.toString() ?? 'N/A'}',
                     style: FlutterFlowTheme.of(context).bodySmall.override(
                       fontFamily: 'SF Pro Display',
                       color: FlutterFlowTheme.of(context).secondaryText,
                       letterSpacing: 0.0,
                       useGoogleFonts: false,
                     ),
                   ),
                 ],
               ),
             ),
           ],
         ),
       ),
     );
   }
   
   Widget _buildSuccessStoryCard(SuccessstoriesRow story) {
     return Container(
       width: double.infinity,
       decoration: BoxDecoration(
         color: FlutterFlowTheme.of(context).secondaryBackground,
         borderRadius: BorderRadius.circular(16.0),
         border: Border.all(
           color: FlutterFlowTheme.of(context).alternate,
           width: 1.0,
         ),
       ),
       child: Padding(
         padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               story.title ?? 'Untitled',
               style: FlutterFlowTheme.of(context).bodyLarge.override(
                 fontFamily: 'SF Pro Display',
                 letterSpacing: 0.0,
                 fontWeight: FontWeight.w600,
                 useGoogleFonts: false,
               ),
             ),
             const SizedBox(height: 8.0),
             Text(
               story.description ?? 'No description available',
               maxLines: 3,
               overflow: TextOverflow.ellipsis,
               style: FlutterFlowTheme.of(context).bodyMedium.override(
                 fontFamily: 'SF Pro Display',
                 letterSpacing: 0.0,
                 useGoogleFonts: false,
               ),
             ),
             const SizedBox(height: 8.0),
             Row(
               mainAxisSize: MainAxisSize.max,
               children: [
                 if (story.sector != null && story.sector!.isNotEmpty)
                   Container(
                     padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                     decoration: BoxDecoration(
                       color: FlutterFlowTheme.of(context).accent1,
                       borderRadius: BorderRadius.circular(8.0),
                     ),
                     child: Text(
                       story.sector!,
                       style: FlutterFlowTheme.of(context).bodySmall.override(
                         fontFamily: 'SF Pro Display',
                         color: FlutterFlowTheme.of(context).primary,
                         letterSpacing: 0.0,
                         fontWeight: FontWeight.w500,
                         useGoogleFonts: false,
                       ),
                     ),
                   ),
                 const SizedBox(width: 8.0),
                 if (story.country != null && story.country!.isNotEmpty)
                   Text(
                     story.country!,
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
         ),
       ),
     );
   }

   Widget _buildPersonCard(CountryInfluencialProfilesRow person) {
     return InkWell(
       splashColor: Colors.transparent,
       focusColor: Colors.transparent,
       hoverColor: Colors.transparent,
       highlightColor: Colors.transparent,
       onTap: () async {
         context.pushNamed(
           'ProminentPersonDetail',
           queryParameters: {
             'personDetails': serializeParam(
               person,
               ParamType.SupabaseRow,
             ),
           }.withoutNulls,
         );
       },
       child: Container(
         width: double.infinity,
         decoration: BoxDecoration(
           color: FlutterFlowTheme.of(context).secondaryBackground,
           borderRadius: BorderRadius.circular(16.0),
           border: Border.all(
             color: FlutterFlowTheme.of(context).alternate,
             width: 1.0,
           ),
         ),
         child: Padding(
           padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
           child: Row(
             mainAxisSize: MainAxisSize.max,
             children: [
               // Profile Image
               Container(
                 width: 60.0,
                 height: 60.0,
                 decoration: BoxDecoration(
                   color: FlutterFlowTheme.of(context).accent1,
                   borderRadius: BorderRadius.circular(30.0),
                   border: Border.all(
                     color: FlutterFlowTheme.of(context).primary,
                     width: 2.0,
                   ),
                 ),
                 child: ClipRRect(
                   borderRadius: BorderRadius.circular(30.0),
                   child: person.image != null && person.image!.isNotEmpty
                       ? Image.network(
                           person.image!,
                           width: 60.0,
                           height: 60.0,
                           fit: BoxFit.cover,
                           errorBuilder: (context, error, stackTrace) {
                             return Container(
                               width: 60.0,
                               height: 60.0,
                               decoration: BoxDecoration(
                                 color: FlutterFlowTheme.of(context).accent1,
                                 borderRadius: BorderRadius.circular(30.0),
                               ),
                               child: Icon(
                                 Icons.person,
                                 color: FlutterFlowTheme.of(context).primary,
                                 size: 30.0,
                               ),
                             );
                           },
                         )
                       : Container(
                           width: 60.0,
                           height: 60.0,
                           decoration: BoxDecoration(
                             color: FlutterFlowTheme.of(context).accent1,
                             borderRadius: BorderRadius.circular(30.0),
                           ),
                           child: Icon(
                             Icons.person,
                             color: FlutterFlowTheme.of(context).primary,
                             size: 30.0,
                           ),
                         ),
                 ),
               ),
               const SizedBox(width: 16.0),
               
               // Person Details
               Expanded(
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       person.name ?? 'Unknown',
                       style: FlutterFlowTheme.of(context).bodyLarge.override(
                         fontFamily: 'SF Pro Display',
                         letterSpacing: 0.0,
                         fontWeight: FontWeight.w600,
                         useGoogleFonts: false,
                       ),
                     ),
                     const SizedBox(height: 4.0),
                     Text(
                       person.company ?? 'Unknown Company',
                       style: FlutterFlowTheme.of(context).bodyMedium.override(
                         fontFamily: 'SF Pro Display',
                         color: FlutterFlowTheme.of(context).primary,
                         letterSpacing: 0.0,
                         fontWeight: FontWeight.w500,
                         useGoogleFonts: false,
                       ),
                     ),
                     const SizedBox(height: 4.0),
                     Text(
                       person.country ?? 'Unknown Country',
                       style: FlutterFlowTheme.of(context).bodySmall.override(
                         fontFamily: 'SF Pro Display',
                         color: FlutterFlowTheme.of(context).secondaryText,
                         letterSpacing: 0.0,
                         useGoogleFonts: false,
                       ),
                     ),
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