import 'package:flutter/material.dart';
import 'package:github_clone/models/user.dart';
import 'package:github_clone/requests/github_request.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  User user;
  String errorMessage;
  bool loading = false;

  Future<bool> fetchUSer(username) async {
    setLoading(true);

    await Github(username).fetchUser().then((data) {
      setLoading(false);

      if (data.statusCode == 200) {
        setUser(User.fromJson(json.decode(data.body)));
      } else {
        print(data.body);
        
        Map<String, dynamic> result = json.decode(data.body);
        setMessage(result['message']);
      }
    });

    return isUser();
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  bool isLoading() {
    return loading;
  }

  User getUser() {
    return user;
  }

  void setUser(value) {
    user = value;
    notifyListeners();
  }

  String getMessage() {
    return errorMessage;
  }

  void setMessage(value) {
    errorMessage = value;
    notifyListeners();
  }

  bool isUser() {
    return user != null ? true : false;
  }
}
