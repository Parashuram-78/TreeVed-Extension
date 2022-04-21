import 'dart:convert';
import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:treeved/models/all_list_model.dart';
import 'package:treeved/models/authenticated_model.dart';
import 'package:treeved/models/user_model.dart';

import '../src/screens/homepage.dart';

class API {
  static const String baseUrl = "api-prod.treeved.com/v1";
  static const String baseUrl2 = "api-dev.treeved.com/v1";
  static const String productionUrl = "https://$baseUrl";
  static const String developmentUrl = "https://$baseUrl2";
  static const String url = productionUrl;
  static const String userDetails = "/users/me/";

  static String get addResource => "/resource/search/url?q=";

  static String addResourceToList(
          {required String listId, required String resourceId}) =>
      "/list/$listId/add-to-list/$resourceId";

  static String addRatingToResource({required String resourceId}) =>
      '/resource/$resourceId/rating/add/';
  static String createDiary = '/diary-entry/add/';

  static String username = window.localStorage["username"] ?? '';
  static String refreshToken = "";
  static String accessToken = "";
  static String tempToken = "";

  static Map<String, String> authHeader = {
    "Content-Type": "application/json",
    "Authorization": "Bearer " + window.localStorage['accessToken']!,
    "charset": "utf-8",
  };
  Map<String, String> jsonheaders = {
    "Content-Type": "application/json",
    "Charset": "utf-8",
  };

  static loginUsingUsernameAndPassword(
      {required String username, required String password}) async {
    var response = await http.post(Uri.parse(url + "/auth/login/"),
        body: {"username": username, "password": password});
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      refreshToken = jsonResponse["refresh"];
      accessToken = jsonResponse["access"];
      window.localStorage["refreshToken"] = refreshToken;
      window.localStorage["accessToken"] = accessToken;
    } else {
      throw Exception("Failed to login");
    }
  }

  static getUserDetails() async {
    var response =
        await http.get(Uri.parse(url + userDetails), headers: authHeader);
    if (response.statusCode == 200) {
      return UserDetails.fromJson(json.decode(response.body));
    }
    return NullThrownError();
  }

  static getUserLists() async {
    var response = await http.get(
        Uri.parse(url + '/list/' + username + '/user-lists'),
        headers: authHeader);
    if (response.statusCode == 200) {
      var raw = json.decode(response.body);
      print("${raw["results"]}");

      return AllListModel.fromJson(json.decode(response.body));
    }

  }

  static createDiaryEntry({
    required BuildContext context,
    required String resourceUrl,
    required String rating,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(url + createDiary),
        headers: authHeader,
        body: json.encode({
          "url": resourceUrl,
          "rating": rating,
          'rating_exists': true,
          'content_exists': true,
          "text": "",
          "topics": [],
          'visibility': 'everyone',
          "resource_type": "other"
        }),
      );
      customSnackBar(context, "Diary Entry created successfully");
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      customSnackBar(context, "Failed to create diary entry");
    }
  }

  static Future<dynamic> withoutInvitesignInWithGoogle(
      BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn(clientId: "516082304162-n27s7oifq5q4n2aqpgu2vth10cbjl0n6.apps.googleusercontent.com");
    GoogleSignInAccount? googleSignInAccount;
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;
    try {
      googleSignInAccount = (await googleSignIn.signIn())!;
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user!;
        var token = await user.getIdToken();
        if (token != null) {
          print("THE ID TOKEN IS $token");
          tempToken = token;
          await continueWithGoogleSignIn(idToken: token, context: context);
          customSnackBar(context, "Logged in successfully!");

          Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => const MyHomePage()),
          );
        }
      }
    } catch (e) {
      print("THE ERROR IS MAIN $e");
    }
  }

  static Future continueWithGoogleSignIn(
      {required String idToken, required BuildContext context}) async {
    var response;
    String data = jsonEncode({"access_token": idToken});
    print("THE RESPONSE CURRENT $response");

    try {
      print("TRY BLOCK ENTER");
      response = await http.post(
          Uri.parse(url + "/auth/social/signin/google-oauth2/"),
          body: data,
          headers: {"Content-Type": "application/json", "Charset": "utf-8"});

      print("THE RESPONSE IJS IS ${jsonDecode(response.body)}");
      print("TRY BLOCK EXIT");
    } catch (e) {
      print("THE ERROR IS $e");
    }
    final token = ApiTokenResponse.fromJson(jsonDecode(response.body));

    AuthenticatedUser user = AuthenticatedUser(
      id: 0,
      username: token.username!,
      accessToken: token.accessToken!,
      refreshToken: token.refreshToken!,
    );
    window.localStorage["refreshToken"] = token.refreshToken!;
    window.localStorage["accessToken"] = token.accessToken!;
    if (response != null) {
      print("THE RESPONSE IS $response");
    }

    return response;
  }

  static addtoList({
    required String addedUrl,
    required BuildContext context,
    required String listId,
    required String rating,
    required String listName,
  }) async {
    try {
      var response = await http.get(Uri.parse(url + addResource + addedUrl),
          headers: authHeader);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        int id = jsonResponse["content"]["id"];
        var respo = await http.patch(
          Uri.parse(url + addResourceToList(listId: listId, resourceId: '$id')),
          headers: authHeader,
          body: json.encode({"rating": rating}),
        );

      }
    } catch (e) {
      customSnackBar(context, e.toString());
    }
  }
}

customSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 8),
    ),
  );
}
