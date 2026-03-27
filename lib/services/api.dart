import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todofrontendapi/models/category.dart';

class ApiService {
  ApiService();

  // Vervang deze URL met de actuele URL die ngrok geeft!
  static const String baseUrl =
      'https://crosby-diazoamino-nontheocratically.ngrok-free.dev'; // 👈 geen trailing slash, geen .dev

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/categories'),
      headers: {
        "Accept": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
    );

    final Map<String, dynamic> data = json.decode(response.body);

    if (!data.containsKey('data') || data['data'] is! List) {
      throw Exception('Failed to load categories');
    }

    List categories = data['data'];

    return categories.map((category) => Category.fromJson(category)).toList();
  }

  Future saveCategory(Category category) async {
    String url = '$baseUrl/api/categories/${category.id}';

    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'name': category.name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update category');
    }
    final Map<String, dynamic> data = json.decode(response.body);
    return Category.fromJson(data['data']);
  }
}
