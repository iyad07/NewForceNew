import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/backend/supabase/supabase.dart';
import '/auth/base_auth_user_provider.dart';
import '/index.dart';
import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;
  bool _splashTransitionInProgress = false;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  // Set this when navigating to auth pages
  void setOnAuthPage(bool value) {
    // We don't need to track this anymore but keeping the method
    // for compatibility with existing code calls
    notifyListeners();
  }

  bool get loading {
    // Simplified loading logic to prevent redirect loops
    return showSplashImage && !_splashTransitionInProgress;
  }

  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;

    // Handle navigation based on auth state
    if (!newUser.loggedIn) {
      print(
          'AppStateNotifier: User not logged in, setting redirect to onboarding');
      setRedirectLocationIfUnset('onboardingPage');
    } else {
      // If user is logged in, clear any redirect to ensure proper navigation
      print('AppStateNotifier: User logged in, clearing redirect');
      clearRedirectLocation();
    }

    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    if (_splashTransitionInProgress) return;

    print('Stopping splash image display');
    _splashTransitionInProgress = true;

    // Force user to be non-null if it's still null at this point
    if (user == null) {
      print('User is null during splash transition, creating empty user');
      update(initialUser ?? EmptyAuthUser());
    }

    // Simply turn off splash image
    showSplashImage = false;
    _splashTransitionInProgress = false;
    notifyListeners();
    print('Splash transition complete');
  }
}

// Empty auth user to prevent null user issues
class EmptyAuthUser extends BaseAuthUser {
  @override
  bool get loggedIn => false;

  @override
  String get uid => '';

  @override
  String? get email => null;

  @override
  String? get displayName => null;

  @override
  String? get photoUrl => null;

  @override
  String? get phoneNumber => null;

  @override
  DateTime? get createdTime => null;

  @override
  bool get emailVerified => false;

  @override
  AuthUserInfo get authUserInfo => const AuthUserInfo(
        uid: '',
        email: null,
        displayName: null,
        photoUrl: null,
        phoneNumber: null,
      );

  @override
  Future? delete() async => null;

  @override
  Future? updateEmail(String email) async => null;

  @override
  Future? sendEmailVerification() async => null;

  @override
  Future refreshUser() async {}
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true, // Enable debug logging for troubleshooting
      refreshListenable: appStateNotifier,
      routerNeglect: true, // Prevents unnecessary rebuilds
      errorBuilder: (context, state) => const OnboardingPageWidget(),
      redirect: (context, state) {
        // Simple redirect logic to prevent stack overflow
        final String currentPath = state.uri.path;
        final bool isLoggedIn = appStateNotifier.loggedIn;
        final bool isShowingSplash = appStateNotifier.showSplashImage;

        // Check if this is a guest access request
        final bool isGuestAccess =
            state.uri.queryParameters['isGuest'] == 'true';

        // Define auth pages for quick checking
        final bool isAuthPage = currentPath == '/onboardingPage' ||
            currentPath == '/signInPage' ||
            currentPath == '/createProfile' ||
            currentPath == '/resetPassword';

        // Don't redirect during splash screen
        if (currentPath == '/' && isShowingSplash) {
          return null;
        }

        // After splash screen ends
        if (currentPath == '/') {
          return isLoggedIn ? '/home' : '/onboardingPage';
        }

        // Allow access to Home if user is logged in OR is accessing as guest
        if (currentPath == '/home' && (isLoggedIn || isGuestAccess)) {
          return null;
        }

        // Redirect to onboarding if not logged in and trying to access protected pages
        if (!isLoggedIn && !isAuthPage && !isGuestAccess) {
          return '/onboardingPage';
        }

        // No redirect needed
        return null;
      },
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn
              ? const NavBarPage()
              : const OnboardingPageWidget(),
        ),
        FFRoute(
          name: 'onboardingPage',
          path: '/onboardingPage',
          builder: (context, params) => const OnboardingPageWidget(),
        ),
        FFRoute(
          name: 'createProfile',
          path: '/createProfile',
          builder: (context, params) => const CreateProfileWidget(),
        ),
        FFRoute(
          name: 'signInPage',
          path: '/signInPage',
          builder: (context, params) => const SignInPageWidget(),
        ),
        FFRoute(
          name: 'resetPassword',
          path: '/resetPassword',
          builder: (context, params) => const ResetPasswordWidget(),
        ),
        FFRoute(
          name: 'Home',
          path: '/home',
          builder: (context, params) {
            // Check if this is guest access
            final isGuest =
                params.getParam<String>('isGuest', ParamType.String) == 'true';

            // If it's guest access or the user is authenticated, allow access
            if (isGuest || appStateNotifier.loggedIn) {
              return params.isEmpty
                  ? const NavBarPage(page: HomeWidget())
                  : const HomeWidget();
            } else {
              // Otherwise redirect to onboarding
              return const OnboardingPageWidget();
            }
          },
          // Skip authentication check for this route
          requireAuth: false,
        ),
        FFRoute(
          name: 'chatHistoryPage',
          path: '/chatHistoryPage',
          builder: (context, params) => const ChatHistoryPageWidget(),
        ),
        FFRoute(
          name: 'arWorld',
          path: '/arWorld',
          builder: (context, params) => params.isEmpty
              ? const NavBarPage(page: ArWorldWidget())
              : const ArWorldWidget(),
        ),
        FFRoute(
          name: 'countryProfile',
          path: '/countryProfile',
          builder: (context, params) => CountryProfileWidget(
            countrydetails: params.getParam<CountryProfilesRow>(
              'countrydetails',
              ParamType.SupabaseRow,
            ),
          ),
        ),
        FFRoute(
          name: 'reels',
          path: '/reels',
          builder: (context, params) => params.isEmpty
              ? const NavBarPage(page: ReelsWidget())
              : const ReelsWidget(),
        ),
        FFRoute(
          name: 'investmentTopic',
          path: '/investmentTopic',
          builder: (context, params) => InvestmentTopicWidget(
            name: params.getParam(
              'name',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'investmentTopicsArticleDetails',
          path: '/investmentTopicsArticleDetails',
          builder: (context, params) => InvestmentTopicsArticleDetailsWidget(
            publlisher: params.getParam(
              'publlisher',
              ParamType.String,
            ),
            publisherImage: params.getParam(
              'publisherImage',
              ParamType.String,
            ),
            timeCreated: params.getParam(
              'timeCreated',
              ParamType.String,
            ),
            articleImage: params.getParam(
              'articleImage',
              ParamType.String,
            ),
            articleDescription: params.getParam(
              'articleDescription',
              ParamType.String,
            ),
            tag: params.getParam(
              'tag',
              ParamType.String,
            ),
            articleNews: params.getParam(
              'articleNews',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'donation',
          path: '/donation',
          builder: (context, params) => const DonationWidget(),
        ),
        FFRoute(
          name: 'feedyourCuriosityTopics',
          path: '/feedyourCuriosityTopics',
          builder: (context, params) => FeedyourCuriosityTopicsWidget(
            tag: params.getParam(
              'tag',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'Game',
          path: '/game',
          builder: (context, params) => params.isEmpty
              ? const NavBarPage(page: GameWidget())
              : const GameWidget(),
        ),
        FFRoute(
          name: 'countryInfluencialFigures',
          path: '/countryInfluencialFigures',
          builder: (context, params) => CountryInfluencialFiguresWidget(
            country: params.getParam(
              'country',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'Settings',
          path: '/settings',
          builder: (context, params) => const SettingsWidget(),
        ),
        FFRoute(
          name: 'aiScreen',
          path: '/aiScreen',
          builder: (context, params) => params.isEmpty
              ? const NavBarPage(page: AiScreenWidget())
              : const AiScreenWidget(),
        ),
        FFRoute(
          name: 'topStocksPage',
          path: '/topStocksPage',
          builder: (context, params) => TopStocksPageWidget(
            country: params.getParam(
              'country',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'topReadArticlesDetails',
          path: '/topReadArticlesDetails',
          builder: (context, params) => TopReadArticlesDetailsWidget(
            publisher: params.getParam(
              'publisher',
              ParamType.String,
            ),
            datepublished: params.getParam(
              'datepublished',
              ParamType.DateTime,
            ),
            publisherPic: params.getParam(
              'publisherPic',
              ParamType.String,
            ),
            articleImage: params.getParam(
              'articleImage',
              ParamType.String,
            ),
            description: params.getParam(
              'description',
              ParamType.String,
            ),
            tag: params.getParam(
              'tag',
              ParamType.String,
            ),
            newsBody: params.getParam(
              'newsBody',
              ParamType.String,
            ),
            title: params.getParam(
              'title',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'feedYourCuriosityArticleDetails',
          path: '/feedYourCuriosityArticleDetails',
          builder: (context, params) => FeedYourCuriosityArticleDetailsWidget(
            publisherImage: params.getParam(
              'publisherImage',
              ParamType.String,
            ),
            publisher: params.getParam(
              'publisher',
              ParamType.String,
            ),
            dateCreated: params.getParam(
              'dateCreated',
              ParamType.DateTime,
            ),
            articleImage: params.getParam(
              'articleImage',
              ParamType.String,
            ),
            description: params.getParam(
              'description',
              ParamType.String,
            ),
            tag: params.getParam(
              'tag',
              ParamType.String,
            ),
            newsbody: params.getParam(
              'newsbody',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'countryNewsDetails',
          path: '/countryNewsDetails',
          builder: (context, params) => CountryNewsDetailsWidget(
            title: params.getParam(
              'title',
              ParamType.String,
            ),
            articleImage: params.getParam(
              'articleImage',
              ParamType.String,
            ),
            description: params.getParam(
              'description',
              ParamType.String,
            ),
            country: params.getParam(
              'country',
              ParamType.String,
            ),
            newsbody: '',
          ),
        ),
        FFRoute(
          name: 'newsFeed',
          path: '/newsFeed',
          builder: (context, params) => params.isEmpty
              ? const NavBarPage(page: NewsFeedWidget())
              : const NewsFeedWidget(),
        ),
        FFRoute(
          name: 'newForceArticleDetails',
          path: '/newForceArticleDetails',
          builder: (context, params) => NewForceArticleDetailsWidget(
            publisher: params.getParam(
              'publisher',
              ParamType.String,
            ),
            articleImage: params.getParam(
              'articleImage',
              ParamType.String,
            ),
            description: params.getParam(
              'description',
              ParamType.String,
            ),
            newsbody: params.getParam(
              'newsbody',
              ParamType.String,
            ),
            title: params.getParam(
              'title',
              ParamType.String,
            ),
            datecreated: params.getParam(
              'datecreated',
              ParamType.DateTime,
            ),
            newsUrl: params.getParam(
              'newsUrl',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'quizquestions',
          path: '/quizquestions',
          builder: (context, params) => const QuizquestionsWidget(),
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : GoRouter.of(this).goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : GoRouter.of(this).pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.setRedirectLocationIfUnset(location);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          // Only handle auth redirects, main redirects are in the router
          if (requireAuth && !appStateNotifier.loggedIn) {
            return '/onboardingPage';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);

          // Build the page content
          Widget pageContent;
          if (ffParams.hasFutures) {
            pageContent = FutureBuilder(
              future: ffParams.completeFutures(),
              builder: (context, _) => builder(context, ffParams),
            );
          } else {
            pageContent = builder(context, ffParams);
          }

          // Skip loading screen for auth pages
          final bool isAuthPage = state.uri.path == '/onboardingPage' ||
              state.uri.path == '/signInPage' ||
              state.uri.path == '/createProfile' ||
              state.uri.path == '/resetPassword';

          // Only show loading screen if not on auth page and splash is still showing
          final bool showLoadingScreen =
              appStateNotifier.showSplashImage && !isAuthPage;

          // Final page widget
          final Widget child = showLoadingScreen
              ? Container(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  child: Center(
                    child: Image.asset(
                      'assets/images/ForceGIFanimation-unscreen.gif',
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : pageContent;

          // Create the page with transitions
          return MaterialPage(
            key: state.pageKey,
            child: child,
          );
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() =>
      const TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext({required this.isRootPage, this.errorRoute});
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(isRootPage: true, errorRoute: errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
