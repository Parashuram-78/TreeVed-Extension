import 'package:flutter/cupertino.dart';
import 'package:treeved/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserDetails? userDetails;

  void setUserDetails({required UserDetails userDetails}) {
    this.userDetails = userDetails;
    notifyListeners();
  }
}
