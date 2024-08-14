import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gemicates/view/home_screen_view.dart';
import 'package:gemicates/view/login_view.dart';
import 'package:provider/provider.dart';
import 'package:gemicates/controller/auth_controller.dart';
import 'package:gemicates/controller/product_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return authProvider.user == null ? LoginPage() : const HomeScreen();
          },
        ),
      ),
    );
  }
}
