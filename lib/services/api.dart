import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todofrontendapi/models/category.dart';
import 'package:todofrontendapi/models/transaction.dart';
import 'package:todofrontendapi/providers/auth_provider.dart';

class ApiService {
  late String? token;
  late AuthProvider? authProvider;

   ApiService(String token, AuthProvider? auth) {
    // ignore: prefer_initializing_formals
    this.token = token;
    authProvider = auth;
  }

  // Vervang deze URL met de actuele URL die ngrok geeft!
  static const String baseUrl =
      'https://crosby-diazoamino-nontheocratically.ngrok-free.dev';

  Future<List<Category>> fetchCategories() async {
    final http.Response response = await http.get(
      Uri.parse('$baseUrl/api/categories'),
      headers: <String, String>{
        'Accept': 'application/json',
        "ngrok-skip-browser-warning": "true",
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
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
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{'name': category.name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update category');
    }
    final Map<String, dynamic> data = json.decode(response.body);
    return Category.fromJson(data['data']);
  }

  Future<void> deleteCategory(id) async {
    String url = '$baseUrl/api/categories/$id';
    final http.Response response = await http.delete(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete category');
    }
  }

  Future addCategory(String name) async {
    String url = '$baseUrl/api/categories';
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{'name': name}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create category');
    }

    final Map<String, dynamic> data = json.decode(response.body);
    return Category.fromJson(data['data']);
  }

  Future<String> register(
    String name,
    String email,
    String password,
    String passwordConfirm,
    String deviceName,
  ) async {
    String url = '$baseUrl/api/auth/register';
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirm,
        'device_name': deviceName,
      }),
    );

    if (response.statusCode == 422) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> errors = data['errors'];
      String message = '';
      errors.forEach((key, value) {
        value.forEach((error) {
          message += '$error\n';
        });
      });

      throw Exception(message);
    }

    return response.body;
  }

  Future<String> login(
    String email,
    String password,
    String deviceName,
  ) async {
    String url = '$baseUrl/api/auth/login';
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'device_name': deviceName,
      }),
    );

    if (response.statusCode == 422) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> errors = data['errors'];
      String message = '';
      errors.forEach((key, value) {
        value.forEach((error) {
          message += '$error\n';
        });
      });

      throw Exception(message);
    }

    return response.body;
  }

  Future<List<Transaction>> fetchTransactions() async {
    http.Response response = await http.get(
      Uri.parse('$baseUrl/api/transactions'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final Map<String, dynamic> data = json.decode(response.body);

    if (!data.containsKey('data') || data['data'] is! List) {
      throw Exception('Failed to load transactions: ${response.body}');
    }

    List transactions = data['data'];
    print('Transactions count: ${transactions.length}');

    return transactions
        .map((transaction) => Transaction.fromJson(transaction))
        .toList();
  }

  Future<Transaction> addTransaction(
    String amount,
    String category,
    String description,
    String date,
  ) async {
    // ignore: prefer_interpolation_to_compose_strings
    String uri = baseUrl + '/api/transactions';
    http.Response response = await http.post(
      Uri.parse(uri),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'amount': amount,
        'category_id': category,
        'description': description,
        'transaction_date': date,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Error happened on create');
    }
    return Transaction.fromJson(jsonDecode(response.body)['data']);
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    // ignore: prefer_interpolation_to_compose_strings
    String uri = baseUrl + '/api/transactions/' + transaction.id.toString();
    http.Response response = await http.put(
      Uri.parse(uri),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'amount': transaction.amount,
        'category_id': transaction.categoryId,
        'description': transaction.description,
        'transaction_date': transaction.transactionDate,
      }),
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Error happened on update');
    }
    return Transaction.fromJson(jsonDecode(response.body)['data']);
  }

  Future<void> deleteTransaction(id) async {
    // ignore: prefer_interpolation_to_compose_strings
    String uri = baseUrl + '/api/transactions/' + id.toString();
    http.Response response = await http.delete(
      Uri.parse(uri),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Error happened on delete');
    }
  }
}
