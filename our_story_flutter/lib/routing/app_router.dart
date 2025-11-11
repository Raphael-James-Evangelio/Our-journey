import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/gallery_manager_page.dart';
import '../pages/landing_page.dart';
import '../pages/login_page.dart';

class AppRouter {
  AppRouter({required Stream<User?> authStream})
      : _authStream = authStream,
        router = GoRouter(
          initialLocation: '/',
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              name: 'landing',
              pageBuilder: _buildFadeTransition(const LandingPage()),
            ),
            GoRoute(
              path: '/login',
              name: 'login',
              pageBuilder: _buildFadeTransition(const LoginPage()),
            ),
            GoRoute(
              path: '/gallery-manager',
              name: 'gallery-manager',
              pageBuilder: _buildFadeTransition(const GalleryManagerPage()),
            ),
          ],
          redirect: (context, state) => _redirectLogic(state),
          refreshListenable: _AuthStateNotifier(authStream),
        );

  final Stream<User?> _authStream;
  final GoRouter router;

  static String? _redirectLogic(GoRouterState state) {
    final location = state.uri.toString();
    final isLoggingIn = location == '/login';
    final isGalleryRoute = location == '/gallery-manager';

    // Try to get current user, but handle cases where Firebase might not be initialized
    User? user;
    try {
      user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      // Firebase not initialized yet, don't redirect
      return null;
    }

    if (user == null && isGalleryRoute) {
      return '/login';
    }
    if (user != null && isLoggingIn) {
      return '/gallery-manager';
    }

    return null;
  }

  static GoRouterPageBuilder _buildFadeTransition(Widget child) {
    return (context, state) {
      return CustomTransitionPage<void>(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      );
    };
  }
}

class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier(Stream<User?> authStream) {
    _subscription = authStream.listen((user) {
      notifyListeners();
    });
  }

  late final StreamSubscription<User?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

