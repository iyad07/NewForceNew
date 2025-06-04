import 'package:new_force_new_hope/google_search/google_search_widget.dart';
import 'package:new_force_new_hope/other_pages/ar_world/camera_kit/camera_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'backend/scrapers/news_provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'auth/supabase_auth/supabase_user_provider.dart';
import 'auth/supabase_auth/auth_util.dart';
import 'package:go_router/go_router.dart';

import '/backend/supabase/supabase.dart';
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

  print('App initialization completed, launching app...');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => appState),
      ChangeNotifierProvider(create: (context) => NewsProvider()),
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

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TNFM',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        scrollbarTheme: const ScrollbarThemeData(),
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(
              allowEnterRouteSnapshotting: false,
            ),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scrollbarTheme: const ScrollbarThemeData(),
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(
              allowEnterRouteSnapshotting: false,
            ),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      themeMode: _themeMode,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
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
      'googleSearch': const GoogleSearchWidget(), // Replace newsFeed with googleSearch
      'arWorld': const MyTest(),
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
            icon: Icon(Icons.search_outlined), // Changed from newspaper to search
            activeIcon: Icon(Icons.search),
            label: 'Search', // Changed from News to Search
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
