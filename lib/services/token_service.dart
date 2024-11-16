// // lib/services/token_service.dart
// import 'package:shared_preferences.dart';

// class TokenService {
//   static const String _tokenKey = 'auth_token';
//   final SharedPreferences _prefs;

//   TokenService(this._prefs);

//   Future<void> saveToken(String token) async {
//     await _prefs.setString(_tokenKey, token);
//   }

//   String? getToken() {
//     return _prefs.getString(_tokenKey);
//   }

//   Future<void> deleteToken() async {
//     await _prefs.remove(_tokenKey);
//   }
// }