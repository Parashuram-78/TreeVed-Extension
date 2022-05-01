import 'package:flutter/material.dart';
import 'package:treeved/controllers/api_handler.dart';

import '../models/all_list_model.dart';

class ListNotifier extends ChangeNotifier {
  late RawListModel rawUserList;
  List<ListModel> myList = [];
  List<ListModel> myPageList = [];
  int getUserListPageKey = 1;
  int getPageListPageKey = 1;

  bool hasMore = false;
  bool hasMorePage = false;
  API listService = API();

  Future getUserList(
      {required bool firstRun,
      int? pageId,
      required isPage}) async {
    if (firstRun) {
      myList.clear();
      notifyListeners();
      getUserListPageKey = 1;
      notifyListeners();
    } else {
      print("Skip clear");
    }

    var response;
    if (isPage) {
      response = await listService.getPageLists(
          pageKey: getUserListPageKey, pageId: pageId!);
    } else {
      response = await listService.getUserLists(pageKey: getUserListPageKey);
    }
    rawUserList = response;
    print("Notifier response is $response");

    if (rawUserList.count > myList.length) {
      hasMore = true;
      notifyListeners();
      await addToUserListArray(myList);
    }

    if (rawUserList.count == myList.length) {
      hasMore = false;
      notifyListeners();
    } else {
      getUserListPageKey++;
    }

    notifyListeners();
  }

  addToUserListArray(List<ListModel> listModel) {
    for (int i = 0; i < rawUserList.results.length; i++) {
      listModel.add(rawUserList.results[i]);
    }
  }
}
