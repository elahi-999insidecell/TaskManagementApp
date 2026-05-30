import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/data/services/apicaller.dart';
import 'package:taskmanager/data/utils/urls.dart';
import 'package:taskmanager/ui/screens/loginpage.dart';
//import 'package:taskmanager/ui/screens/pin_verify.dart';
import 'package:taskmanager/ui/utils/screen_background.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //form er jonno key lage
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //method likhbo, nicheo lekha jay
  bool _signUpInProgress = false;

  //clear korbo controller gula jodi success hoy
  _clearControllers() {
    _emailController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _mobileController.clear();
    _passwordController.clear();
  }

  Future<void> _signUp() async {
    setState(() {
      _signUpInProgress = true;
    });

    Map<String, dynamic> requestBody = {
      "email": _emailController.text,
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "mobile": _mobileController.text,
      "password": _passwordController.text,
    };
    final ApiResponse response = await Apicaller.postRequest(
      url: Urls.registrationUrl,
      body: requestBody,
    );

    //api call response pawar por abar setState diye _signUpInProgress false kore dibo, jate button abar active hoy
    setState(() {
      _signUpInProgress = false;
    });

    if (response.isSuccess) {
      _clearControllers();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sign Up successful!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
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
  Widget build(BuildContext context) {
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
                  const SizedBox(height: 90),
                  Text(
                    "Join With Us",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "Email"),
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
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(hintText: "First Name"),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your first name";
                      }

                      if (value.trim().length < 2) {
                        //trim removes space between the characters

                        return "First name must be at least 2 characters long";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(hintText: "Last Name"),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your first name";
                      }

                      if (value.trim().length < 2) {
                        return "Last name must be at least 2 characters long";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _mobileController,
                    decoration: InputDecoration(hintText: "Mobile"),
                    validator: (String? val) {
                      if (val == null || val.isEmpty) {
                        return "Please enter your valid mobile number";
                      }

                      if (val.trim().length != 11) {
                        return "Enter valid phone number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
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
                  Visibility(
                    //visibility diye wrapped karon double click na hoy button e, ar progress bar dekha jay
                    visible: !_signUpInProgress,

                    replacement: Center(child: CircularProgressIndicator()),
                    child: FilledButton(
                      onPressed: _signUpInProgress
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _signUp();
                              }
                            },
                      child: Icon(Icons.arrow_forward),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Have Account? ",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          TextSpan(
                            text: "Sign in",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),

                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LogInPage(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
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

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
  }
}
