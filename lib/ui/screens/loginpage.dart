// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/userModel.dart';
import 'package:taskmanager/data/services/apicaller.dart';
import 'package:taskmanager/data/utils/urls.dart';
import 'package:taskmanager/ui/controller/auth_controller.dart';
import 'package:taskmanager/ui/screens/forgetpassemail.dart';
import 'package:taskmanager/ui/screens/mainnavholder.dart';
import 'package:taskmanager/ui/screens/sign_up.dart';
import 'package:taskmanager/ui/utils/screen_background.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LoginpageState();
}

class _LoginpageState extends State<LogInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //again formkey hehe
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  bool _logINProgress = false;

  @override
  Widget build(BuildContext context) {
    void onTapForgetPassword() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Forgetpassemail()),
      );
    }

    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),
                  Text(
                    "Get Started With",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }

                      final emailRegExp = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegExp.hasMatch(value)) {
                        return "Please enter a valid email ";
                      }
                      return null;
                    },
                    decoration: InputDecoration(hintText: "Email"),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }

                      if (value.trim().length <= 6) {
                        return "Password must be at least 6 or more characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(hintText: "Password"),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _logIn();
                      }
                    },
                    child: Icon(Icons.arrow_forward_ios_sharp),
                  ),
                  const SizedBox(height: 35),

                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            onTapForgetPassword();
                          },
                          child: Text(
                            "Forget Password?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account?",
                            children: [
                              TextSpan(
                                text: " Sign Up",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),

                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignUp(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _clearControllers() {
    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> _logIn() async {
    setState(() {
      _logINProgress = true;
    });

    Map<String, dynamic> requestBody = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };
    final ApiResponse response = await Apicaller.postRequest(
      url: Urls.loginUrl,
      body: requestBody,
    );

    //api call response pawar por abar setState diye _logInProgress false kore dibo, jate button abar active hoy
    setState(() {
      _logINProgress = false;
    });

    if (response.isSuccess) {
UserModel model = UserModel.fromJson(response.responseData["data"]);

      //data nicchi cause response is coming in this way

      String accessToken = response.responseData["token"];
      //etao anlam response theke
      await AuthController.saveUserData(model, accessToken);

      _clearControllers();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Log In successful!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Mainnavholder()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.responseData['data']),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
