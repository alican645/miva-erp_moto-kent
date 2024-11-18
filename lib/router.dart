import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/pages/error_page.dart';
import 'package:moto_kent/pages/post_screen_page.dart';
import 'package:moto_kent/pages/register_page.dart'; // RegisterPage import edildi
import 'package:moto_kent/pages/profile_page.dart';
import 'package:moto_kent/widgets/app_layout.dart';
import 'pages/login_page.dart';

final _routerKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: "/login_page",
  navigatorKey: _routerKey,
  routes: [
    GoRoute(
      path: "/login_page",
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: "/register_page",  // Yeni register_page rotası eklendi
      builder: (context, state) => RegisterPage(),
    ),
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/post_screen_page",
            builder: (context, state) => PostScreenPage(),
              ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/profile_page",
            builder: (context, state) => const ProfilePage(),
          ),
        ]),
      ],
      builder: (context, state, navigationShell) =>
          AppLayout(statefulNavigationShell: navigationShell),
    ),
  ],
);
