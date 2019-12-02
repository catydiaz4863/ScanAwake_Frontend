import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:scanawake/models/user.dart';

class AppBloc extends ChangeNotifier {
  bool isReady = false;
  bool isLoggedIn = false;
  bool didLoginFail = false;
  bool didLoadFail = false;
  User myAccount;
  String token;

  String chosenTitle = "default";
  String chosenURL = "";
  List<String> titles = List<String>();
  List<String> urls = List<String>();
  String deezerKEY = "3b40ebf5a48debdd33cf1e497c9025df";
  String deezerID = "382824";

/*
  AppBloc() {
    setup();
  }


  Future<void> setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = (prefs.getString('token') ?? null);
    if (token != null) {
      isLoggedIn = true;
      notifyListeners();
      loadData();
    }
    
  }

  Future<void> loadData() async {
    if (isLoggedIn) {
      bool fetchedTimeline = await fetchTimeline();
      bool fetchedAccount = await fetchAccount();
      if (fetchedTimeline && fetchedAccount) {
        print("is ready");
        isReady = true;
        notifyListeners();
      } else {
        print("is not ready");
        didLoadFail = true;
        notifyListeners();
      }
    }else{
      print("not logged in");
    }
  }
*/

  Future<void> attemptLogin(String username, String password) async {
    print(
        "attempting login https://nameless-escarpment-45560.herokuapp.com/api/login?username=$username&password=$password");
    var response = await http.get(
        "https://nameless-escarpment-45560.herokuapp.com/api/login?username=$username&password=$password");
    if (response.statusCode == 200) {
      print("succeeded login");
      didLoginFail = false;
      Map<String, dynamic> jsonData = json.decode(response.body);
      token = jsonData["token"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      if (token != null) {
        isLoggedIn = true;
      }
      notifyListeners();
    } else {
      print(response.body);
      print("login did not succeed");
      didLoginFail = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    isLoggedIn = false;
    notifyListeners();
  }

  Future<bool> searchAudio(String keyword) async {
    titles.clear();
    urls.clear();
    var response = await http.get("https://api.deezer.com/search?q=$keyword",
        headers: {'secret_key': "$deezerKEY", 'app_id': "$deezerID"});

    if (response.statusCode == 200) {
      Map<String, dynamic> jsondata = json.decode(response.body);
      for (int i = 0; i < jsondata["data"].length; i++)
      {
        
        print(jsondata["data"][i]["title"]);
        print(jsondata["data"][i]["preview"]);
        titles.add(jsondata["data"][i]["title"].toString());
        urls.add(jsondata["data"][i]["preview"].toString());
      }
      return true;
    }
    return false;
  }

/*
  Future<bool> fetchTimeline() async {
    var response = await http.get(
        "https://nameless-escarpment-45560.herokuapp.com/api/v1/posts",
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if(response.statusCode == 200){
      List<dynamic> serverPosts = json.decode(response.body);
      for(int i = 0; i < serverPosts.length; i++){
        timeline.add(Post.fromJson(serverPosts[i]));

      }
      return true;
    }
    return false;
  }

  Future<bool> fetchAccount() async {
    print("getting account data");
    var response = await http.get(
        "https://nameless-escarpment-45560.herokuapp.com/api/v1/my_account",
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode == 200) {
      myAccount = User.fromJson(json.decode(response.body));

      print("getting account posts");
      var my_posts_response = await http.get(
          "https://nameless-escarpment-45560.herokuapp.com/api/v1/my_posts",
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
      if (my_posts_response.statusCode == 200) {
        print("successfully got account posts");
        List<dynamic> server_posts = json.decode(my_posts_response.body);
        my_posts = server_posts.map((p) => Post.fromJson(p)).toList();
        return true;
      }
    } else {
      print(response.body);
      print("account load failed");
    }
    return false;
  }
  */
}
