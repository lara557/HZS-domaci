import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:3000';
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Inicijalizuj secure storage
  static final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      keyCipherAlgorithm:
          KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
  );

  // Čuva token u sigurnoj memoriji
  static Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: token);
    } catch (e) {
      print('Greška pri čuvanju tokena: $e');
    }
  }

  // Čuva user podatke u sigurnoj memoriji
  static Future<void> saveUserData(Map<String, dynamic> user) async {
    try {
      await _secureStorage.write(key: _userKey, value: jsonEncode(user));
    } catch (e) {
      print('Greška pri čuvanju korisničkih podataka: $e');
    }
  }

  // Učitava token iz sigurne memorije
  static Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      print('Greška pri čitanju tokena: $e');
      return null;
    }
  }

  // Učitava user podatke iz sigurne memorije
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final data = await _secureStorage.read(key: _userKey);
      if (data != null) {
        return jsonDecode(data);
      }
      return null;
    } catch (e) {
      print('Greška pri čitanju korisničkih podataka: $e');
      return null;
    }
  }

  // Obriši token i user podatke
  static Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _userKey);
    } catch (e) {
      print('Greška pri brisanju tokena: $e');
    }
  }

  // Registracija korisnika
  static Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'email': email,
              'password': password,
              'confirmPassword': confirmPassword,
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Registracija uspešna!'};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message':
              data['messages'] ?? data['message'] ?? 'Greška pri registraciji',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Greška konekcije: $e'};
    }
  }

  // Login korisnika
  static Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Sačuvaj token u sigurnu memoriju
        await saveToken(data['token']);

        // Sačuvaj user podatke u sigurnu memoriju
        await saveUserData(data['user']);

        return {
          'success': true,
          'message': 'Login uspešan!',
          'token': data['token'],
          'user': data['user'],
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Login neuspešan',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Greška konekcije: $e'};
    }
  }

  // Primer zaštićenog API poziva sa JWT tokenom
  static Future<Map<String, dynamic>> getProtectedData() async {
    try {
      final token = await getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Token nije pronađen. Molim vas da se ponovo prijavite.',
        };
      }

      final response = await http
          .get(
            Uri.parse('$_baseUrl/protected'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else if (response.statusCode == 401) {
        // Token istekao - obriši ga
        await deleteToken();
        return {
          'success': false,
          'message': 'Sesija je istekla. Molim vas da se ponovo prijavite.',
          'expired': true,
        };
      } else {
        return {'success': false, 'message': 'Greška pri učitavanju podataka'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Greška konekcije: $e'};
    }
  }

  // Logout
  static Future<void> logout() async {
    await deleteToken();
  }

  // Provera da li je korisnik prijavljen
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
