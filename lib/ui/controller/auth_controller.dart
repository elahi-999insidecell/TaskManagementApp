import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanager/data/models/userModel.dart';

class AuthController {
  static final String _accessTokenKey = 'token';
  static final String _userModelKey = 'user-data';

  static String? accessToken;
  static UserModel? userModel;

  static Future saveUserData(UserModel model, String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    await sharedPreferences.setString(
      _userModelKey,
      jsonEncode(model.toJson()),
    );
    accessToken = token;
    userModel = model;
    //apatoto kaaje na lagle onno page theke jkhn call korbo tokhn accessToken and userModel er value pabo, karon ekhane set kore disi
    //print(sharedPreferences.getString(_accessTokenKey));
  }

  static Future getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);

    if (token != null) {
      String? userData = sharedPreferences.getString(_userModelKey);
      userModel = UserModel.fromJson(jsonDecode(userData!));
      //set string theke usermodel diye data nilam
    }
  }

  //check if user is logged in or not
  static Future<bool> isUserLoggedIn() async {
    SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    String? token = sharedpreferences.getString(_accessTokenKey);
    if (token != null) {
      return true;
    } else {
      return false;
    }

    //or evabeo kora jay je: return != null;
  }

  //logout
  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

  // save photo
  static Future<void> saveProfilePhoto(String path) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("profile_photo", path);
  }

  static Future<String?> getProfilePhoto() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("profile_photo");
  }
}
