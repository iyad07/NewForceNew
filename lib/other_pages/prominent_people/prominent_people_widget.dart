import 'package:flutter/material.dart';

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
import 'african_richest_detail_widget.dart';
import 'success_story_detail_widget.dart';
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

  // Test method to check raw data
  Future<void> _testDataFetch() async {
    try {
      print('Testing data fetch...');
      
      // Test African Richest
      final africanRichestResponse = await SupaFlow.client
          .from('africanRichest')
          .select()
          .limit(5);
      print('African Richest Raw Response: $africanRichestResponse');
      
      // Test Influential Figures
      final influentialResponse = await SupaFlow.client
          .from('influentialFigures')
          .select()
          .limit(5);
      print('Influential Figures Raw Response: $influentialResponse');
      
      // Test Success Stories
      final successResponse = await SupaFlow.client
          .from('successStories')
          .select()
          .limit(5);
      print('Success Stories Raw Response: $successResponse');
      
    } catch (e) {
      print('Error testing data fetch: $e');
    }
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
                  labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'SF Pro Display',
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                    useGoogleFonts: false,
                  ),
                  unselectedLabelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'SF Pro Display',
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w400,
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
                  buttonMargin: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
                  padding: const EdgeInsets.all(4.0),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 16.0,
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            'Richest',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'SF Pro Display',
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.business_center,
                            size: 16.0,
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            'Leaders',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'SF Pro Display',
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 16.0,
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            'Success',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'SF Pro Display',
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: false,
                            ),
                          ),
                        ],
                      ),
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
      child: FutureBuilder<List<dynamic>>(
        future: SupaFlow.client.from('africanRichest').select(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading African richest people:',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'SF Pro Display',
                      color: FlutterFlowTheme.of(context).error,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'SF Pro Display',
                      color: FlutterFlowTheme.of(context).error,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
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
           
           List<dynamic> rawData = snapshot.data!;
           print('African Richest Data Count: ${rawData.length}');
           print('First item: ${rawData.isNotEmpty ? rawData.first : 'No data'}');
           
           if (rawData.isEmpty) {
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
           
           // Sort the data by net worth in descending order (richest first)
           rawData.sort((a, b) {
             final aNetworth = _parseNetworth(a['Networth']);
             final bNetworth = _parseNetworth(b['Networth']);
             return bNetworth.compareTo(aNetworth); // Descending order
           });
           
           return ListView.separated(
             padding: EdgeInsets.zero,
             scrollDirection: Axis.vertical,
             itemCount: rawData.length,
             separatorBuilder: (_, __) => const SizedBox(height: 12.0),
             itemBuilder: (context, index) {
               final item = rawData[index] as Map<String, dynamic>;
               return _buildAfricanRichestCard(item);
             },
           );
         },
       ),
     );
   }
   
   Widget _buildInfluentialFiguresTab() {
     return Padding(
       padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
       child: FutureBuilder<List<dynamic>>(
         future: SupaFlow.client.from('influentialFigures').select(),
         builder: (context, snapshot) {
           if (snapshot.hasError) {
             return Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text(
                     'Error loading influential figures:',
                     style: FlutterFlowTheme.of(context).bodyMedium.override(
                       fontFamily: 'SF Pro Display',
                       color: FlutterFlowTheme.of(context).error,
                       letterSpacing: 0.0,
                       useGoogleFonts: false,
                     ),
                     textAlign: TextAlign.center,
                   ),
                   SizedBox(height: 8),
                   Text(
                     '${snapshot.error}',
                     style: FlutterFlowTheme.of(context).bodySmall.override(
                       fontFamily: 'SF Pro Display',
                       color: FlutterFlowTheme.of(context).error,
                       letterSpacing: 0.0,
                       useGoogleFonts: false,
                     ),
                     textAlign: TextAlign.center,
                   ),
                 ],
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
           
           List<dynamic> rawData = snapshot.data!;
           print('Influential Figures Data Count: ${rawData.length}');
           print('First item: ${rawData.isNotEmpty ? rawData.first : 'No data'}');
           
           if (rawData.isEmpty) {
             return Center(
               child: Text(
                 'No influential figures found.',
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
             itemCount: rawData.length,
             separatorBuilder: (_, __) => const SizedBox(height: 12.0),
             itemBuilder: (context, index) {
               final item = rawData[index] as Map<String, dynamic>;
               return _buildPersonCard(item);
             },
           );
         },
       ),
     );
   }
   
   Widget _buildSuccessStoriesTab() {
     return Padding(
       padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
       child: FutureBuilder<List<dynamic>>(
         future: SupaFlow.client.from('successStories').select(),
         builder: (context, snapshot) {
           if (snapshot.hasError) {
             return Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text(
                     'Error loading success stories:',
                     style: FlutterFlowTheme.of(context).bodyMedium.override(
                       fontFamily: 'SF Pro Display',
                       color: FlutterFlowTheme.of(context).error,
                       letterSpacing: 0.0,
                       useGoogleFonts: false,
                     ),
                     textAlign: TextAlign.center,
                   ),
                   SizedBox(height: 8),
                   Text(
                     '${snapshot.error}',
                     style: FlutterFlowTheme.of(context).bodySmall.override(
                       fontFamily: 'SF Pro Display',
                       color: FlutterFlowTheme.of(context).error,
                       letterSpacing: 0.0,
                       useGoogleFonts: false,
                     ),
                     textAlign: TextAlign.center,
                   ),
                 ],
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
           
           List<dynamic> rawData = snapshot.data!;
           print('Success Stories Data Count: ${rawData.length}');
           print('First item: ${rawData.isNotEmpty ? rawData.first : 'No data'}');
           
           if (rawData.isEmpty) {
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
             itemCount: rawData.length,
             separatorBuilder: (_, __) => const SizedBox(height: 12.0),
             itemBuilder: (context, index) {
               final item = rawData[index] as Map<String, dynamic>;
               return _buildSuccessStoryCard(item);
             },
           );
         },
       ),
     );
   }
   
   Widget _buildAfricanRichestCard(Map<String, dynamic> person) {
  return InkWell(
    splashColor: Colors.transparent,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: () async {
      // Navigate to African Richest detail page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AfricanRichestDetailWidget(person: person),
        ),
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
            _buildProfileImage(person),
            const SizedBox(width: 16.0),
            
            // Person Details
            Expanded(
              child: _buildPersonDetails(person),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildProfileImage(Map<String, dynamic> person) {
  final imageUrl = person['Image']?.toString() ?? person['Pics']?.toString();
  
  return Container(
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
      child: (imageUrl != null && imageUrl.isNotEmpty)
          ? Image.network(
              imageUrl,
              width: 60.0,
              height: 60.0,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildDefaultAvatar();
              },
            )
          : _buildDefaultAvatar(),
    ),
  );
}

Widget _buildDefaultAvatar() {
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
}

Widget _buildPersonDetails(Map<String, dynamic> person) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Name
      Text(
        person['Name']?.toString() ?? 'Unknown',
        style: FlutterFlowTheme.of(context).bodyLarge.override(
          fontFamily: 'SF Pro Display',
          letterSpacing: 0.0,
          fontWeight: FontWeight.w600,
          useGoogleFonts: false,
        ),
      ),
      const SizedBox(height: 4.0),
      
      // Company or Net Worth
      Text(
        person['Company']?.toString() ?? 
        'Net Worth: ${person['Networth']?.toString() ?? 'N/A'}',
        style: FlutterFlowTheme.of(context).bodyMedium.override(
          fontFamily: 'SF Pro Display',
          color: FlutterFlowTheme.of(context).primary,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w500,
          useGoogleFonts: false,
        ),
      ),
      const SizedBox(height: 4.0),
      
      // Country or Age
      Text(
        person['Country']?.toString() ?? 
        'Age: ${person['Age']?.toString() ?? 'N/A'}',
        style: FlutterFlowTheme.of(context).bodySmall.override(
          fontFamily: 'SF Pro Display',
          color: FlutterFlowTheme.of(context).secondaryText,
          letterSpacing: 0.0,
          useGoogleFonts: false,
        ),
      ),
    ],
  );
}
   
   Widget _buildSuccessStoryCard(Map<String, dynamic> story) {
     return InkWell(
       splashColor: Colors.transparent,
       focusColor: Colors.transparent,
       hoverColor: Colors.transparent,
       highlightColor: Colors.transparent,
       onTap: () async {
         // Navigate to Success Story detail page
         Navigator.push(
           context,
           MaterialPageRoute(
             builder: (context) => SuccessStoryDetailWidget(story: story),
           ),
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
         child: Column(
           mainAxisSize: MainAxisSize.min,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             // Image Section
             if (story['Image URL'] != null && story['Image URL'].toString().isNotEmpty)
               ClipRRect(
                 borderRadius: const BorderRadius.only(
                   topLeft: Radius.circular(16.0),
                   topRight: Radius.circular(16.0),
                 ),
                 child: CachedNetworkImage(
                   fadeInDuration: const Duration(milliseconds: 500),
                   fadeOutDuration: const Duration(milliseconds: 500),
                   imageUrl: story['Image URL'].toString(),
                   width: double.infinity,
                   height: 200.0,
                   fit: BoxFit.cover,
                   placeholder: (context, url) => Container(
                     width: double.infinity,
                     height: 200.0,
                     color: FlutterFlowTheme.of(context).alternate,
                     child: Center(
                       child: Icon(
                         Icons.image_outlined,
                         color: FlutterFlowTheme.of(context).secondaryText,
                         size: 40.0,
                       ),
                     ),
                   ),
                   errorWidget: (context, url, error) => Container(
                     width: double.infinity,
                     height: 200.0,
                     color: FlutterFlowTheme.of(context).alternate,
                     child: Center(
                       child: Icon(
                         Icons.broken_image_outlined,
                         color: FlutterFlowTheme.of(context).secondaryText,
                         size: 40.0,
                       ),
                     ),
                   ),
                 ),
               ),
             
             // Content Section
             Padding(
               padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     story['Title']?.toString() ?? 'Untitled',
                     style: FlutterFlowTheme.of(context).bodyLarge.override(
                       fontFamily: 'SF Pro Display',
                       letterSpacing: 0.0,
                       fontWeight: FontWeight.w600,
                       useGoogleFonts: false,
                     ),
                   ),
                   const SizedBox(height: 8.0),
                   Text(
                     story['Description']?.toString() ?? 'No description available',
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
                   if (story['Sector'] != null && story['Sector'].toString().isNotEmpty)
                     Container(
                       padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                       decoration: BoxDecoration(
                         color: FlutterFlowTheme.of(context).accent1,
                         borderRadius: BorderRadius.circular(8.0),
                       ),
                       child: Text(
                         story['Sector'].toString(),
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
                   if (story['Country'] != null && story['Country'].toString().isNotEmpty)
                     Text(
                       story['Country'].toString(),
                       style: FlutterFlowTheme.of(context).bodySmall.override(
                         fontFamily: 'SF Pro Display',
                         color: FlutterFlowTheme.of(context).secondaryText,
                         letterSpacing: 0.0,
                         useGoogleFonts: false,
                       ),
                     ),
                   ],
                 ),
           ]),
         ),
         ])));
   }

   Widget _buildPersonCard(Map<String, dynamic> person) {
  return InkWell(
    splashColor: Colors.transparent,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: () async {
      // Create a row object for navigation
      final personRow = CountryInfluencialProfilesRow(person);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProminentPersonDetailWidget(person: personRow),
        ),
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
                child: person['Image'] != null && person['Image'].toString().isNotEmpty
                    ? Image.network(
                        person['Image'].toString(),
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
                    person['Name']?.toString() ?? 'Unknown',
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'SF Pro Display',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts: false,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    person['Company']?.toString() ?? 'Unknown Company',
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
                    person['Country']?.toString() ?? 'Unknown Country',
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
            
            // Navigation Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 16.0,
            ),
          ],
        ),
      ),
    ),
  );
}

  // Helper method to parse net worth string into a numerical value for sorting
  double _parseNetworth(dynamic networth) {
    if (networth == null) return 0.0;
    
    String networthStr = networth.toString().toLowerCase().trim();
    
    // Remove currency symbols and common prefixes
    networthStr = networthStr.replaceAll(RegExp(r'[\$,\s]'), '');
    
    // Extract the numerical part
    RegExp numberRegex = RegExp(r'([0-9]*\.?[0-9]+)');
    Match? match = numberRegex.firstMatch(networthStr);
    
    if (match == null) return 0.0;
    
    double baseValue = double.tryParse(match.group(1) ?? '0') ?? 0.0;
    
    // Handle billion, million, thousand multipliers
    if (networthStr.contains('billion') || networthStr.contains('b')) {
      return baseValue * 1000000000;
    } else if (networthStr.contains('million') || networthStr.contains('m')) {
      return baseValue * 1000000;
    } else if (networthStr.contains('thousand') || networthStr.contains('k')) {
      return baseValue * 1000;
    }
    
    return baseValue;
  }
}