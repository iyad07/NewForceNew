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

// This is the main entry point of the Flutter application
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Configure routing options
  GoRouter.optionURLReflectsImperativeAPIs = false;
  usePathUrlStrategy();

  // Initialize services in parallel to speed up app startup
  await Future.wait([
    // Initialize Supabase with error handling
    () async {
      try {
        print('Starting Supabase initialization...');
        await SupaFlow.initialize();
        print('Supabase initialization completed successfully');
      } catch (e) {
        print('Error initializing Supabase: $e');
        // Continue anyway to prevent app from hanging
      }
    }(),
    // Initialize the app's theme
    FlutterFlowTheme.initialize(),
  ]);

  // Initialize the app state
  final appState = FFAppState();
  await appState.initializePersistedState();

  print('App initialization completed, launching app...');

  // Run the app with ChangeNotifierProvider for state management
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => appState),
      ChangeNotifierProvider(create: (context) => NewsProvider()),
    ],
    child: const MyApp(),
  ));
}

// MyApp is the root widget of the application
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  // This allows accessing the app's state from anywhere in the widget tree
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  // Manage the app's theme mode (light/dark)
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  // Stream for authentication state
  late Stream<BaseAuthUser> userStream;

  @override
  void initState() {
    super.initState();

    // Initialize app state and routing
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    // Use a more efficient initialization approach
    _initializeApp();
  }

  // Helper method to initialize Supabase with optimized performance
  Future<void> initializeSupabase() async {
    try {
      // Use the existing Supabase initialization from SupaFlow
      if (!SupaFlow.isInitialized) {
        await SupaFlow.initialize();
      }
      return;
    } catch (e) {
      print('Error in initializeSupabase: $e');
      // Continue app flow even if Supabase fails
      return;
    }
  }

  // Separate method for app initialization to improve performance
  Future<void> _initializeApp() async {
    // Start a timer to track initialization performance
    final stopwatch = Stopwatch()..start();

    try {
      // Initialize Supabase if not already initialized
      await initializeSupabase();

      // Initialize other services if needed
      // Add other initialization here if required

      print(
          'All services initialized successfully in ${stopwatch.elapsedMilliseconds}ms');

      // Set up authentication stream - only after services are initialized
      userStream = tnfmSupabaseUserStream()
        ..listen((user) {
          print(
              'Auth state changed: user=${user?.loggedIn}, email=${user?.email}');
          _appStateNotifier.update(user);

          // Explicitly navigate to onboarding for new users
          if (user == null || !user.loggedIn) {
            print('User not logged in, setting redirect to onboarding');
            _router.setRedirectLocationIfUnset('onboardingPage');
          }
        });
      jwtTokenStream.listen((_) {});

      // Calculate remaining time for splash screen
      final int remainingTime = 2000 - stopwatch.elapsedMilliseconds;
      final int splashDelay = remainingTime > 0 ? remainingTime : 0;

      // Hide splash screen after initialization or minimum time
      Future.delayed(
        Duration(milliseconds: splashDelay),
        () {
          if (mounted) {
            print(
                'Normal timeout: Stopping splash image after ${stopwatch.elapsedMilliseconds}ms');
            _appStateNotifier.stopShowingSplashImage();
            // Force navigation to onboarding if not logged in
            if (_appStateNotifier.user == null || !_appStateNotifier.loggedIn) {
              print(
                  'User not logged in after splash, navigating to onboarding');
              // Set auth page flag before navigation
              _appStateNotifier.setOnAuthPage(true);
              _router.go('/onboardingPage');
            }
          }
        },
      );
    } catch (error) {
      print('Error initializing services: $error');
    }

    // Add a fallback timeout to force exit loading state
    Future.delayed(
      const Duration(seconds: 8),
      () {
        if (mounted) {
          print('Fallback timeout: Ensuring app exits loading state');
          _appStateNotifier.stopShowingSplashImage();

          // Force update user if it's null
          if (_appStateNotifier.user == null) {
            print('User still null at fallback timeout, forcing empty user');
            _appStateNotifier.update(tnfmSupabaseUserFromSupabaseAuth(null));

            // Force navigation to onboarding
            print('Forcing navigation to onboarding page');
            // Set auth page flag before navigation
            _appStateNotifier.setOnAuthPage(true);
            _router.go('/onboardingPage');
          }
        }
      },
    );
  }

  // Method to change the app's theme
  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    // MaterialApp.router is the main app configuration
    return MaterialApp.router(
      title: 'TNFM',
      // Configure localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      // Configure light theme
      theme: ThemeData(
        brightness: Brightness.light,
        scrollbarTheme: const ScrollbarThemeData(),
        // Optimize performance
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
      // Configure dark theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scrollbarTheme: const ScrollbarThemeData(),
        // Optimize performance
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
      // Optimize router performance
      routerConfig: _router,
      // Disable debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}

// NavBarPage handles the bottom navigation bar
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
    // Define the pages for each tab
    final tabs = {
      'Home': const HomeWidget(),
      // AI screen removed from tabs but code kept
      // 'aiScreen': const AiScreenWidget(),
      'newsFeed': const NewsFeedWidget(),
      'arWorld': const MyTest(),
      'reels': const ReelsWidget(),
      'Game': const GameWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    // Scaffold provides the basic app structure
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
            icon: Icon(Icons.newspaper_outlined),
            activeIcon: Icon(Icons.newspaper),
            label: 'News',
            tooltip: '',
          ),
          // AI page removed from navigation but code kept
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.chat_bubble_outline),
          //   activeIcon: Icon(Icons.chat_bubble),
          //   label: 'AI',
          //   tooltip: '',
          // ),
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
