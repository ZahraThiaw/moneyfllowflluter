// widgets/transaction_card.dart
import 'package:flutter/material.dart';
import 'package:moneyflow/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionCardItem extends StatelessWidget {
  final Transaction transaction;
  final String currentUserPhone;

  const TransactionCardItem({
    Key? key,
    required this.transaction,
    required this.currentUserPhone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isOutgoing = transaction.expediteur.telephone == currentUserPhone;
    String description = '';
    String amount = '';

    switch (transaction.type) {
      case 'TRANSFERT':
        if (isOutgoing) {
          description = 'À ${transaction.destinataire.prenom} ${transaction.destinataire.nom}';
          amount = '-${transaction.montantTotal}';
        } else {
          description = 'De ${transaction.expediteur.prenom} ${transaction.expediteur.nom}';
          amount = '+${transaction.montant}';
        }
        break;
      default:
        description = transaction.type;
        amount = transaction.montant.toString();
    }

    // Formatage de la date
    final formattedDate = DateFormat('dd MMM, HH:mm', 'fr_FR').format(transaction.date);

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    description,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Text(
              '${amount}F',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isOutgoing ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}