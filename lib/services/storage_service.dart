import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneyflow/models/user.dart';

class StorageService {
  static const String _userBoxName = 'user_box';

  Future<void> init() async {
    await Hive.initFlutter();
    
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }
    
    if (!Hive.isBoxOpen(_userBoxName)) {
      await Hive.openBox<User>(_userBoxName);
    }
  }

  Future<void> saveUser(User user) async {
    final userBox = await _getUserBox();
    await userBox.put('user', user);
  }

  User? getUser() {
    final userBox = Hive.box<User>(_userBoxName);
    return userBox.get('user');
  }

  Future<void> deleteUser() async {
    final userBox = await _getUserBox();
    await userBox.delete('user');
  }

  Future<Box<User>> _getUserBox() async {
    if (!Hive.isBoxOpen(_userBoxName)) {
      await Hive.openBox<User>(_userBoxName);
    }
    return Hive.box<User>(_userBoxName);
  }
}