import 'dart:convert';
import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:treeved/models/all_list_model.dart';
import 'package:treeved/models/authenticated_model.dart';
import 'package:treeved/models/user_model.dart';
import 'package:treeved/providers/user_provider.dart';
import 'package:treeved/src/screens/add_resource_screen.dart';

import '../models/page_model.dart';
import '../src/screens/homepage.dart';

class API {
  static const String baseUrl = "api-prod.treeved.com/v1";
  static const String baseUrl2 = "api-dev.treeved.com/v1";
  static const String productionUrl = "https://$baseUrl";
  static const String developmentUrl = "https://$baseUrl2";
  static const String url = productionUrl;
  static const String userDetails = "/users/me/";

  static String get addResource => "/resource/search/url?q=";

/*  static final corsHeader = {"access-control-allow-origin": '*',};*/

  static String addResourceToList({required String listId, required String resourceId}) => "/list/$listId/add-to-list/$resourceId";

  static String addRatingToResource({required String resourceId}) => '/resource/$resourceId/rating/add/';
  static String createDiary = '/diary-entry/add/';

  static String username = window.localStorage["username"] ?? '';
  static String refreshToken = "";
  static String accessToken = "";
  static String tempToken = "";

  static Map<String, String> authHeader = {
    "Content-Type": "application/json",
    "Authorization": "Bearer " + window.localStorage['accessToken']!,
  };
  Map<String, String> jsonheaders = {
    "Content-Type": "application/json",
    "Charset": "utf-8",
  };

  static loginUsingUsernameAndPassword({required String username, required String password}) async {
    var response = await http.post(Uri.parse(url + "/auth/login/"), body: {"username": username, "password": password});

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

  refreshTokens() async {
    print("the refresh token isk ${window.localStorage["refreshToken"]}");
    var response = await http.post(Uri.parse(url + "/auth/login/refresh/"),
        body: jsonEncode({
          "refresh": window.localStorage["refreshToken"]!,
        }),
        headers: authHeader);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      accessToken = jsonResponse["access"];

      window.localStorage["accessToken"] = accessToken;
    } else {
      throw Exception("Failed to refresh token");
    }
  }

  static getUserDetails() async {
    var response = await http.get(Uri.parse(url + userDetails), headers: authHeader);

    if (response.statusCode == 200) {
      return UserDetails.fromJson(json.decode(response.body));
    }
    return NullThrownError();
  }

  getUserLists({required int pageKey}) async {
    var response = await http.get(Uri.parse(url + '/list/' + username + '/user-lists' + "?page=$pageKey"), headers: authHeader);
    print("The user list url is ${url + '/list/' + username + '/user-lists' + "?page=$pageKey"}");
    print("The user list response is ${response.body}");

    if (response.statusCode == 200) {
      var raw = json.decode(response.body);

      return RawListModel.fromJson(json.decode(response.body));
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
      customSnackBar(context, "Diary Entry created successfully", "");
      var decodedResponse = json.decode(response.body);
      var tempId = Provider.of<UserProvider>(context, listen: false).tempId = decodedResponse["data"]["id"];
      print("The temp id is $tempId");
      print("The response is ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      customSnackBar(context, "Failed to create diary entry", "");
    }
  }

  static Future<dynamic> withoutInvitesignInWithGoogle(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn(clientId: "516082304162-n27s7oifq5q4n2aqpgu2vth10cbjl0n6.apps.googleusercontent.com");
    GoogleSignInAccount? googleSignInAccount;
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;
    try {
      googleSignInAccount = (await googleSignIn.signIn())!;
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        AuthCredential credential =
            GoogleAuthProvider.credential(accessToken: googleSignInAuthentication.accessToken, idToken: googleSignInAuthentication.idToken);
        UserCredential userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user!;
        var token = await user.getIdToken();
        if (token != null) {
          print("THE ID TOKEN IS $token");
          tempToken = token;
          await continueWithGoogleSignIn(idToken: token, context: context);
          customSnackBar(context, "Logged in successfully!", "");

          Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => const MyHomePage()),
          );
        }
      }
    } catch (e) {
      print("THE ERROR IS MAIN $e");
    }
  }

  static Future continueWithGoogleSignIn({required String idToken, required BuildContext context}) async {
    var response;
    String data = jsonEncode({"access_token": idToken});

    try {
      response = await http
          .post(Uri.parse(url + "/auth/social/signin/google-oauth2/"), body: data, headers: {"Content-Type": "application/json", "Charset": "utf-8"});
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
      var response = await http.get(Uri.parse(url + addResource + addedUrl), headers: authHeader);

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
      customSnackBar(context, e.toString(), "");
    }
  }

  static Future<RawMyPage> getMyPages() async {
    final response = await http.get(Uri.parse(url + "/page/mypages/"), headers: authHeader);
    print("THE RESPONSE IS PAGES ${response.body}");
    return RawMyPage.fromJson(json.decode(response.body));
  }

  getPageLists({required int pageId, required int pageKey}) async {
    var response = await http.get(Uri.parse(url + '/page/$pageId/list/all/' + "?page=$pageKey"), headers: authHeader);

    print("The endpoint is ${url + '/page/$pageId/list/all/' + "?page=$pageKey"}");

    print("The page response is ${response.body}");

    if (response.statusCode == 200) {
      var raw = json.decode(response.body);

      return RawPageListModel.fromJson(raw);
    }
  }

  Future shareAsPost({required int id, required BuildContext context}) async {
    final response = await http.post(
      Uri.parse(url + '/diary-entry/$id/share-as-post'),
      headers: authHeader,
      body: "",
    );
    print("Share as post respnse is ${response.body}");
    customSnackBar(context, "Diary Entry Shared as post", "");
    return response;
  }
}

customSnackBar(BuildContext context, String message, String listName) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Text(message),
          Text(
            " $listName",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
