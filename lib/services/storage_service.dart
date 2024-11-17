// lib/services/storage_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneyflow/models/user.dart';
import 'package:moneyflow/models/auth_token.dart';

class StorageService {
  static const String _userBoxName = 'user_box';
  static const String _tokenBoxName = 'token_box';

  Future<void> init() async {
    await Hive.initFlutter();
    
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }
    
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(AuthTokenAdapter());
    }
    
    if (!Hive.isBoxOpen(_userBoxName)) {
      await Hive.openBox<User>(_userBoxName);
    }
    
    if (!Hive.isBoxOpen(_tokenBoxName)) {
      await Hive.openBox<AuthToken>(_tokenBoxName);
    }
  }

  Future<void> saveUser(User user) async {
    final userBox = await _getUserBox();
    await userBox.put('user', user);
  }

  Future<void> saveAuthToken(String token) async {
    final tokenBox = await _getTokenBox();
    final authToken = AuthToken(
      token: token,
      createdAt: DateTime.now(),
    );
    await tokenBox.put('token', authToken);
  }

  User? getUser() {
    final userBox = Hive.box<User>(_userBoxName);
    return userBox.get('user');
  }

  AuthToken? getAuthToken() {
    final tokenBox = Hive.box<AuthToken>(_tokenBoxName);
    return tokenBox.get('token');
  }

  Future<void> deleteUser() async {
    final userBox = await _getUserBox();
    await userBox.delete('user');
  }

  Future<void> deleteAuthToken() async {
    final tokenBox = await _getTokenBox();
    await tokenBox.delete('token');
  }

  Future<Box<User>> _getUserBox() async {
    if (!Hive.isBoxOpen(_userBoxName)) {
      await Hive.openBox<User>(_userBoxName);
    }
    return Hive.box<User>(_userBoxName);
  }

  Future<Box<AuthToken>> _getTokenBox() async {
    if (!Hive.isBoxOpen(_tokenBoxName)) {
      await Hive.openBox<AuthToken>(_tokenBoxName);
    }
    return Hive.box<AuthToken>(_tokenBoxName);
  }

  Future<void> clearAll() async {
    await deleteUser();
    await deleteAuthToken();
  }
}