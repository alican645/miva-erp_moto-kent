import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/pages/home_page.dart';
import 'package:moto_kent/Models/post_model.dart';
import 'package:moto_kent/pages/groups_page.dart';
import 'package:moto_kent/pages/post_content_screen_page.dart';
import 'package:moto_kent/pages/post_screen_page.dart';
import 'package:moto_kent/pages/profile_page.dart';
import 'pages/error_page.dart';
import 'pages/login_page.dart';

final _routerKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: "/login_page",
  navigatorKey: _routerKey,
  errorBuilder: (context, state) => ErrorPage(), // Hata durumunu işlemek için ErrorPage ekledim
  routes: [
    GoRoute(
      path: "/login_page",
      builder: (context, state) => LoginPage(),
    ),
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/post_screen_page",
            builder: (context, state) => PostScreenPage(),
            routes: [
              GoRoute(
                path: "post_content_screen_page",
                builder: (context, state) {
                  final postModel = state.extra as PostModel?;
                  if (postModel == null) {
                    return ErrorPage(); // Hata durumu
                  }
                  return PostContentScreenPage(postModel: postModel);
                },
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/chat_groups_page",
            builder: (context, state) => const ChatGroupsPage(),
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
          HomePage(statefulNavigationShell: navigationShell),
    )
  ],
);
