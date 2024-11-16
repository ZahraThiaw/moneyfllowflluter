// lib/models/user.dart
import 'package:hive/hive.dart';

part 'user.g.dart';  // Ceci sera généré automatiquement par build_runner

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String nom;

  @HiveField(2)
  final String prenom;

  @HiveField(3)
  final String telephone;

  @HiveField(4)
  final String email;

  @HiveField(5)
  final String? token;

  @HiveField(6)
  final String type;

  @HiveField(7)
  final double solde;

  @HiveField(8)
  final String? qrcode;

  @HiveField(9)
  final String statut;

  @HiveField(10)
  final double plafonnd;

  @HiveField(11)
  final bool enabled;

  @HiveField(12)
  final String createdAt;

  @HiveField(13)
  final String updatedAt;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.email,
    this.token,
    required this.type,
    required this.solde,
    this.qrcode,
    required this.statut,
    required this.plafonnd,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      telephone: json['telephone'] as String,
      email: json['email'] as String,
      type: json['type'] as String,
      solde: (json['solde'] as num).toDouble(),
      qrcode: json['qrcode'] as String?,
      statut: json['statut'] as String,
      plafonnd: (json['plafonnd'] as num).toDouble(),
      enabled: json['enabled'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  factory User.fromLoginResponse(Map<String, dynamic> json, String telephone) {
    return User(
      id: json['id'] as int,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      telephone: telephone,
      email: json['email'] as String,
      token: json['token'] as String?,
      type: json['type'] as String,
      solde: (json['solde'] as num).toDouble(),
      qrcode: json['qrcode'] as String?,
      statut: json['statut'] as String,
      plafonnd: (json['plafonnd'] as num).toDouble(),
      enabled: json['enabled'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  factory User.fromProfileResponse(Map<String, dynamic> json) {
    final userData = json;
    return User(
      id: userData['id'] as int,
      nom: userData['nom'] as String,
      prenom: userData['prenom'] as String,
      telephone: userData['telephone'] as String,
      email: userData['email'] as String,
      type: userData['type'] as String,
      solde: (userData['solde'] as num).toDouble(),
      qrcode: userData['qrcode'] as String?,
      statut: userData['statut'] as String,
      plafonnd: (userData['plafonnd'] as num).toDouble(),
      enabled: userData['enabled'] as bool,
      createdAt: userData['createdAt'] as String,
      updatedAt: userData['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'email': email,
      'token': token,
      'type': type,
      'solde': solde,
      'qrcode': qrcode,
      'statut': statut,
      'plafonnd': plafonnd,
      'enabled': enabled,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}