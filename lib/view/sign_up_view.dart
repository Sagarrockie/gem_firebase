import 'package:flutter/material.dart';
import 'package:gemicates/view/login_view.dart';
import 'package:provider/provider.dart';

import '../Utils/app_colors.dart';
import '../Utils/app_widgets.dart';
import '../controller/auth_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  void signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<AuthProvider>(context, listen: false).signUp(
            emailController.text.trim(),
            passwordController.text.trim(),
            nameController.text.trim(),
            context);
      } catch (e) {
        print('Failed to sign up: $e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sign Up Failed'),
              content: const Text('Check your credentials and try again.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        titleSpacing: 19,
        backgroundColor: AppColors.backgroundColor,
        title: const Text(
          'e-Shop',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    WidgetUtils.pingoTextField(nameController, 'Name', false,
                        validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name.';
                      }
                      return null;
                    }),
                    WidgetUtils.pingoTextField(emailController, 'Email', false,
                        validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an email address.';
                      } else if (!isValidEmail(value)) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    }),
                    WidgetUtils.pingoTextField(
                        passwordController, 'Password', true,
                        validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password.';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long.';
                      }
                      return null;
                    }),
                  ],
                ),
              ),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return authProvider.isSignUpLoading
                      ? const CircularProgressIndicator()
                      : WidgetUtils.pingoButton(context, 'Sign Up', () {
                          if (_formKey.currentState!.validate()) {
                            signUp(context);
                          }
                        });
                },
              ),
              const SizedBox(height: 13),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: 'Log in',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String value) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }
}
