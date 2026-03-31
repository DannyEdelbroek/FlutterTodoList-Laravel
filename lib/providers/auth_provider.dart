import 'package:flutter/material.dart';
import 'package:todofrontendapi/services/api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  late String token;
  ApiService apiService = ApiService('', null);// 
  final storage = FlutterSecureStorage();

  AuthProvider() {
    getToken().then((value) {
      if (value != null) {
        token = value;
        isAuthenticated = true;
        notifyListeners();
      }
    });
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
    String deviceName,
  ) async {
    token = await apiService.register(
      name,
      email,
      password,
      passwordConfirmation,
      deviceName,
    );
    setToken(token);
    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> login(String email, String password, String deviceName) async {
    token = await apiService.login(email, password, deviceName);
    setToken(token);
    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    token = '';
    isAuthenticated = false;
    notifyListeners();
  }

  Future<String?> getToken() {
    Future<String?> token = storage.read(key: 'token');
    return Future.value(token);
  }

  Future<String?> setToken(String token) async {
    await storage.write(key: 'token', value: token);

    return token;
  }
}
