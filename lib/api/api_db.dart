import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _baseUrl = "http://192.168.0.102/api_elearning/";
// String _baseUrl = "https://mobile.mppm.cc/_online_mppm_api/";

class ApiDb {
  // Future<Response> registerUser() async {
  //   //IMPLEMENT USER REGISTRATION
  // }

  Future login(String username, String password) async {
    try {
      Response response = await post(Uri.parse('${_baseUrl}login.php'),
          body: {'username': username, 'password': password});
      //returns the successful user data json object
      // print(response.body.toString());
      return jsonDecode(response.body.toString());
    } catch (e) {
      //returns the error object if any
      return e.toString();
    }
  }

  // Future<Response> getUserProfileData() async {
  //   //GET USER PROFILE DATA
  // }

  Future logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    } catch (e) {
      return e.toString();
    }
  }
}
