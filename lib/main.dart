import 'package:flutter/material.dart';
import './Screens/Auth/login.dart';
import './Screens/Auth/register.dart';
import './Screens/categories/categories_list.dart';
import 'package:todofrontendapi/providers/category_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CategoryProvider>(
              create: (context) => CategoryProvider()),
        ],
        child: MaterialApp(
          title: 'Welcome to Flutter',
          home: Login(),
          routes: {
            '/login': (context) => Login(),
            '/register': (context) => Register(),
            '/categories': (context) => CategoriesList(),
          },
        ));
  } 
}
