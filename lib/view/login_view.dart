import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gemicates/Utils/app_colors.dart';
import 'package:gemicates/controller/auth_controller.dart';
import 'package:gemicates/view/sign_up_view.dart';
import 'package:provider/provider.dart';
import '../Utils/app_widgets.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginPage({super.key});

  void signIn(BuildContext context) async {
    try {
      await Provider.of<AuthProvider>(context, listen: false).signIn(
          emailController.text.trim(), passwordController.text.trim(), context);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to sign in: $e');
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sign In Failed'),
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
                    WidgetUtils.pingoTextField(emailController, 'Email', false,
                        validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    }),
                    WidgetUtils.pingoTextField(
                      passwordController,
                      'Password',
                      true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return authProvider.isLoginLoading
                      ? const CircularProgressIndicator()
                      : WidgetUtils.pingoButton(context, 'Login', () {
                          if (_formKey.currentState!.validate()) {
                            signIn(context);
                          }
                        });
                },
              ),
              const SizedBox(height: 13),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: 'New here? ',
                    style: TextStyle(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                    children: [
                      TextSpan(
                        text: 'Sign up',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
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
}
