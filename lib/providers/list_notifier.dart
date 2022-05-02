import 'package:flutter/material.dart';
import 'package:treeved/controllers/api_handler.dart';
import 'package:treeved/models/collection_model.dart';

import '../models/all_list_model.dart';

class ListNotifier extends ChangeNotifier {
  late RawListModel rawUserList;
  late RawPageListModel rawPageListModel;
  List<ListModel> myList = [];
  List<ListModel> myPageList = [];
  int getUserListPageKey = 1;
  int getPageListPageKey = 1;

  bool hasMore = false;
  bool hasMorePage = false;
  API listService = API();

  Future getUserList(
      {required bool firstRun, int? pageId, required isPage}) async {
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
      rawPageListModel = response;
      if (rawPageListModel.count > myList.length) {
        hasMore = true;
        notifyListeners();
        await addToUserListArray(myList, rawPageListModel);
      }

      if (rawPageListModel.count == myList.length) {
        hasMore = false;
        notifyListeners();
      } else {
        getUserListPageKey++;
      }
    } else {
      response = await listService.getUserLists(pageKey: getUserListPageKey);
      rawUserList = response;
      if (rawUserList.count > myList.length) {
        hasMore = true;
        notifyListeners();
        await addToUserListArray(myList, rawUserList);
      }

      if (rawUserList.count == myList.length) {
        hasMore = false;
        notifyListeners();
      } else {
        getUserListPageKey++;
      }
    }

    print("Notifier response is $response");

    notifyListeners();
  }

  addToUserListArray(List<ListModel> listModel, dynamic rawModel) {
    for (int i = 0; i < rawModel.results.length; i++) {
      listModel.add(rawModel.results[i]);
    }
  }
}
