import 'package:new_force_new_hope/google_search/google_search_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'backend/scrapers/news_provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'auth/supabase_auth/supabase_user_provider.dart';
import 'auth/supabase_auth/auth_util.dart';
import 'package:go_router/go_router.dart';

import '/backend/supabase/supabase.dart';
import '/community_hub/community_hub_widget.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoRouter.optionURLReflectsImperativeAPIs = false;
  usePathUrlStrategy();

  await Future.wait([
    () async {
      try {
        print('Starting Supabase initialization...');
        await SupaFlow.initialize();
        print('Supabase initialization completed successfully');
      } catch (e) {
        print('Error initializing Supabase: $e');
      }
    }(),
    FlutterFlowTheme.initialize(),
  ]);

  final appState = FFAppState();
  await appState.initializePersistedState();

  final newsProvider = EnhancedNewsProvider();
  
  try {
    print('Initializing news from local storage...');
    await newsProvider.initializeFromLocalStorage();
    print('News local storage initialization completed');
  } catch (e) {
    print('Error initializing news from local storage: $e');
  }

  print('App initialization completed, launching app...');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => appState),
      ChangeNotifierProvider.value(value: newsProvider),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  late Stream<BaseAuthUser> userStream;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    _initializeApp();
  }

  Future<void> initializeSupabase() async {
    try {
      if (!SupaFlow.isInitialized) {
        await SupaFlow.initialize();
      }
      return;
    } catch (e) {
      print('Error in initializeSupabase: $e');
      return;
    }
  }

  Future<void> _initializeApp() async {
    final stopwatch = Stopwatch()..start();

    try {
      await initializeSupabase();
      
      _startBackgroundNewsUpdate();

      print(
          'All services initialized successfully in ${stopwatch.elapsedMilliseconds}ms');

      userStream = tnfmSupabaseUserStream()
        ..listen((user) {
          print(
              'Auth state changed: user=${user?.loggedIn}, email=${user?.email}');
          _appStateNotifier.update(user);

          if (user == null || !user.loggedIn) {
            print('User not logged in, setting redirect to onboarding');
            _router.setRedirectLocationIfUnset('onboardingPage');
          }
        });
      jwtTokenStream.listen((_) {});

      final int remainingTime = 2000 - stopwatch.elapsedMilliseconds;
      final int splashDelay = remainingTime > 0 ? remainingTime : 0;

      Future.delayed(
        Duration(milliseconds: splashDelay),
        () {
          if (mounted) {
            print(
                'Normal timeout: Stopping splash image after ${stopwatch.elapsedMilliseconds}ms');
            _appStateNotifier.stopShowingSplashImage();
            if (_appStateNotifier.user == null || !_appStateNotifier.loggedIn) {
              print(
                  'User not logged in after splash, navigating to onboarding');
              _appStateNotifier.setOnAuthPage(true);
              _router.go('/onboardingPage');
            }
          }
        },
      );
    } catch (error) {
      print('Error initializing services: $error');
    }

    Future.delayed(
      const Duration(seconds: 8),
      () {
        if (mounted) {
          print('Fallback timeout: Ensuring app exits loading state');
          _appStateNotifier.stopShowingSplashImage();

          if (_appStateNotifier.user == null) {
            print('User still null at fallback timeout, forcing empty user');
            _appStateNotifier.update(tnfmSupabaseUserFromSupabaseAuth(null));

            print('Forcing navigation to onboarding page');
            _appStateNotifier.setOnAuthPage(true);
            _router.go('/onboardingPage');
          }
        }
      },
    );
  }

  void _startBackgroundNewsUpdate() {
    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        try {
          final newsProvider = context.read<EnhancedNewsProvider>();
          print('Starting background news update...');
          await newsProvider.fetchAllNews();
          print('Background news update completed');
        } catch (e) {
          print('Background news update failed: $e');
        }
      }
    });
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: validateAppState(_buildMainApp()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              useMaterial3: false,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: false,
            ),
            themeMode: _themeMode,
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/ForceGIFanimation-unscreen.gif',
                        width: 120.0,
                        height: 120.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Consumer<EnhancedNewsProvider>(
                      builder: (context, newsProvider, child) {
                        final hasData = newsProvider.africanNews.isNotEmpty ||
                                      newsProvider.feedYourCuriosityNews.isNotEmpty ||
                                      newsProvider.investmentNews.isNotEmpty;
                        
                        return Column(
                          children: [
                            Text(
                              hasData ? 'Loading updates...' : 'Setting up your news feed...',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (hasData)
                              Text(
                                'Using cached content while updating',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return snapshot.data ?? _buildMainApp();
      },
    );
  }

  Widget _buildMainApp() {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'New Force New Hope',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key, this.initialPage, this.page});

  final String? initialPage;
  final Widget? page;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'Home';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'Home': const HomeWidget(),
      'investmentPage': const InvestmentPageWidget(),
      'communityHub': const CommunityHubWidget(),
      'arWorld': const ArWorldWidget(),
      'reels': const ReelsWidget(),
      'Game': const GameWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        selectedItemColor: FlutterFlowTheme.of(context).primary,
        unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            activeIcon: Icon(Icons.trending_up),
            label: 'Investment',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            activeIcon: Icon(Icons.forum),
            label: 'Community',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_in_ar_outlined),
            activeIcon: Icon(Icons.view_in_ar),
            label: 'AR',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection_outlined),
            activeIcon: Icon(Icons.video_collection),
            label: 'Reels',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad_outlined),
            activeIcon: Icon(Icons.gamepad),
            label: 'Game',
            tooltip: '',
          ),
        ],
      ),
    );
  }
}

class NewsLoadingWidget extends StatelessWidget {
  const NewsLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EnhancedNewsProvider>(
      builder: (context, newsProvider, child) {
        if (!newsProvider.isLoading) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.blue.shade50,
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Updating news in background...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}