import 'package:flutter/cupertino.dart';
import 'package:treeved/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserDetails? userDetails;
  int tempId = 0 ;
  String tempToken = "";

  void setUserDetails({required UserDetails userDetails}) {
    this.userDetails = userDetails;
    notifyListeners();
  }
  void nullifyUserDetails() {
    userDetails = null;
    notifyListeners();
  }




}
