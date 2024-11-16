// lib/models/transaction.dart
//import 'package:flutter/foundation.dart';

class TransactionUser {
  final String id;
  final String nom;
  final String prenom;
  final String telephone;
  final String? qrcode;
  final String type;
  final double solde;
  final String statut;
  final double plafonnd;

  TransactionUser({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.qrcode,
    required this.type,
    required this.solde,
    required this.statut,
    required this.plafonnd,
  });

  factory TransactionUser.fromJson(Map<String, dynamic> json) {
    return TransactionUser(
      id: json['_id'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      telephone: json['telephone'] ?? '',
      qrcode: json['qrcode'],
      type: json['type'] ?? '',
      solde: (json['solde'] ?? 0).toDouble(),
      statut: json['statut'] ?? '',
      plafonnd: (json['plafonnd'] ?? 0).toDouble(),
    );
  }
}

class Transaction {
  final String id;
  final String type;
  final double montant;
  final double frais;
  final double montantTotal;
  final DateTime date;
  final TransactionUser expediteur;
  final TransactionUser destinataire;
  final String status;
  final String? description;

  Transaction({
    required this.id,
    required this.type,
    required this.montant,
    required this.frais,
    required this.montantTotal,
    required this.date,
    required this.expediteur,
    required this.destinataire,
    required this.status,
    this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      montant: (json['montant'] ?? 0).toDouble(),
      frais: (json['frais'] ?? 0).toDouble(),
      montantTotal: (json['montantTotal'] ?? 0).toDouble(),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      expediteur: TransactionUser.fromJson(json['expediteur'] ?? {}),
      destinataire: TransactionUser.fromJson(json['destinataire'] ?? {}),
      status: json['status'] ?? '',
      description: json['description'],
    );
  }
}
