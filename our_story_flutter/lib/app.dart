import 'package:flutter/material.dart';

import 'routing/app_router.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';

class OurStoryApp extends StatefulWidget {
  const OurStoryApp({super.key});

  @override
  State<OurStoryApp> createState() => _OurStoryAppState();
}

class _OurStoryAppState extends State<OurStoryApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(
      authStream: AuthService.instance.authStateChanges,
    );
  }

  @override
  Widget build(BuildContext context) {
    final router = _appRouter.router;

    return MaterialApp.router(
      title: 'Our Story',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}

