import 'package:flutter/material.dart';
import 'package:nurse_psc/design_course/home_design_course.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../api/api_db.dart';
import '../../loading/loading_screen.dart';
// import '../../Signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ApiDb _apiDb = ApiDb();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUsers() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (_formKey.currentState!.validate()) {
      LoadingScreen().show(context: context, text: 'Mohon Tunggu...');

      dynamic data = await _apiDb.login(
        usernameController.text,
        passwordController.text,
      );

      // print(usernameController.text);
      // print(passwordController.text);
      // print(data);

      if (data['error'] == 'Invalid User') {
        LoadingScreen().hide();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              const Text('Periksa kembali nama pengguna / kata sandi Anda'),
          // content: Text('Error: ${data['error']}'),
          backgroundColor: Colors.red.shade300,
        ));
        _apiDb.logout();
      } else {
        if (data['token'] != null) {
          print(data);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', data['token'].toString());
          prefs.setString('id', passwordController.text);
          prefs.setString('id_user', usernameController.text);
          prefs.setString('username', data['id_sopir'].toString());
          LoadingScreen().hide();
          _completeLogin();
        } else {
          LoadingScreen().hide();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                const Text('Periksa kembali nama pengguna / kata sandi Anda'),
            // content: Text('Error: ${data['error']}'),
            backgroundColor: Colors.red.shade300,
          ));
        }
      }
    }
  }

  void _completeLogin() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const DesignCourseHomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextField(
            controller: usernameController,
            // keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            // onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Your username",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
                loginUsers();
              },
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
          ),
          // const SizedBox(height: defaultPadding),
          // AlreadyHaveAnAccountCheck(
          //   press: () {
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(
          //     //     builder: (context) {
          //     //       return const SignUpScreen();
          //     //     },
          //     //   ),
          //     // );
          //   },
          // ),
        ],
      ),
    );
  }
}
