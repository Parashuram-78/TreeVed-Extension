import 'dart:html';

import 'package:flutter/material.dart';
import 'package:treeved/src/screens/add_resource_screen.dart';
import 'package:treeved/src/screens/privacy_policy_screen.dart';

import 'package:velocity_x/velocity_x.dart';

import '../main.dart';
import '../src/screens/homepage.dart';
import '../src/screens/login_screen.dart';

class Routes {
  static const String privacy_policy = '/privacy-policy';
  static const String login = '/login';
}

final routesDelegate = VxNavigator(
  notFoundPage: (uri, params) => MaterialPage(
      child: Center(
    child: Text('Not Found'),
  )),
  observers: [
    MyObs(),
  ],
  routes: {
    "/": (context, parmas) {
      if (window.localStorage["username"] != null) {
        return MaterialPage(
          child: MyHomePage(),
        );
      } else {
        return MaterialPage(
          child: LoginScreen(),
        );
        ;
      }
    },
    Routes.privacy_policy: (context, params) {
      return MaterialPage(
        child: PrivacyPolicyScreen(
          isMainScreen: params,
        ),
      );
    },
    Routes.login: (context, params) {
      return MaterialPage(
        child: LoginScreen(),
      );
    },
  },
);

class MyObs extends VxObserver {
  @override
  void didChangeRoute(Uri route, Page page, String pushOrPop) {
    print("THE PAGE IS ${page} ${route.path}${route.queryParameters}");
  }

  @override
  void didPush(Route route, Route? previousRoute) {}

  @override
  void didPop(Route route, Route? previousRoute) {}
}
