import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/gallery_manager_page.dart';
import '../pages/landing_page.dart';
import '../pages/login_page.dart';

class AppRouter {
  AppRouter({required Stream<User?> authStream})
      : router = GoRouter(
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
          redirect: (context, state) {
            final location = state.uri.toString();
            final isLoggingIn = location == '/login';
            final isGalleryRoute = location == '/gallery-manager';
            final user = FirebaseAuth.instance.currentUser;

            if (user == null && isGalleryRoute) {
              return '/login';
            }
            if (user != null && isLoggingIn) {
              return '/gallery-manager';
            }

            return null;
          },
          refreshListenable: GoRouterRefreshStream(authStream),
        );

  final GoRouter router;

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

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((event) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

