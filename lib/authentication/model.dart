import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
final apiUri = 'http://127.0.0.1:8000';
class LoginAuth {
  String email;
  String password;
  LoginAuth( {required this.email, required this.password});
  
  Future<bool> login() async {
    // api call with email and password
    print(email);
    print(password);

    final response = await http.post(
      Uri.parse('$apiUri/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      String session_token = jsonDecode(response.body)['token'];

      print(session_token);

      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return false;
    }


    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? emilShared = prefs.getString('email');
    // String? passwordShared = prefs.getString('password');
    
    // print(emilShared);
    // print(passwordShared);
    // if (email == emilShared && password == passwordShared) {
    //   return true;
    // }
    // else {
    //   return false;
    // }
  }
}

class SignUpAuth {
  String email;
  String password;

  SignUpAuth({required this.email, required this.password});
  
  Future<bool> login() async {
    print(email);
    print(password);

    if (email == 'sudiipkumarbasu@gmail.com' && password == '12345678') {
      // Get an instance of SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Set the string values using await
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      
      print('success');
      return true;
    }
    else {
      return false;
    }
  }
}