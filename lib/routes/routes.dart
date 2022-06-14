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
  static const String add_respurce_screen = '/add-resource';
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
      return MaterialPage(
          child: MyHomePage(),
        );

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


    Routes.add_respurce_screen: (context, params) {
      return MaterialPage(
        child: AddResourceScreen(),
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
