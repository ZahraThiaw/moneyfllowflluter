// lib/models/auth_token.dart
import 'package:hive/hive.dart';

part 'auth_token.g.dart';

@HiveType(typeId: 1)
class AuthToken extends HiveObject {
  @HiveField(0)
  final String token;

  @HiveField(1)
  final DateTime createdAt;

  AuthToken({
    required this.token,
    required this.createdAt,
  });
}