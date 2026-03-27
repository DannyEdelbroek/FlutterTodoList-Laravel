import 'package:flutter/material.dart';
import './Screens/Auth/login.dart';
import './Screens/Auth/register.dart';
import './Screens/categories/categories_list.dart';
import 'package:todofrontendapi/providers/category_provider.dart';
import 'package:todofrontendapi/providers/auth_provider.dart';
import 'package:todofrontendapi/screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<CategoryProvider>(
                create: (context) => CategoryProvider(authProvider)), 
            ],
            child: MaterialApp(
              title: 'Welcome to Flutter',
              routes: {
                '/': (context) {
                  final authProvider = Provider.of<AuthProvider>(context);
                  return authProvider.isAuthenticated ? CategoriesList() : Login();
                },
                '/login': (context) => Login(),
                '/register': (context) => Register(),
                '/home': (context) => Home(),
                '/categories': (context) => CategoriesList(),
              },
            ),
          );
        },
      ),
    );
  }
}
