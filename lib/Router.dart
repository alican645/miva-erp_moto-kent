import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/HomePage.dart';
import 'package:moto_kent/Models/PostModel.dart';
import 'package:moto_kent/Screens/GroupsPage.dart';
import 'package:moto_kent/Screens/PostContentScreenPage.dart';
import 'package:moto_kent/Screens/PostScreenPage.dart';
import 'package:moto_kent/Screens/ProfilePage.dart';


final _routerKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
    initialLocation: "/postScreenPage",
    navigatorKey: _routerKey,
    routes: [
      StatefulShellRoute.indexedStack(
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
                path: "/postScreenPage",
                builder: (context, state) => PostScreenPage(),
                routes: [
                  GoRoute(
                    path: "postContentScreenPage",
                    builder: (context, state) {
                      final postModel = state.extra as PostModel?;
                      return PostContentScreenPage(postModel: postModel!);
                    },
                  )
                ]),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: "/postScreenPage1",
              builder: (context, state) => PostScreenPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: "/postScreenPage2",
              builder: (context, state) => PostScreenPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: "/chatGroupsPage",
              builder: (context, state) => ChatGroupsPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: "/profilePage",
              builder: (context, state) => ProfilePage(),
            ),
          ]),
        ],
        builder: (context, state, navigationShell) =>
            HomePage(statefulNavigationShell: navigationShell),
      )
    ]);
