// lib/widgets/transaction_card_item.dart
import 'package:flutter/material.dart';
import 'package:moneyflow/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class TransactionCardItem extends StatefulWidget {
  final Transaction transaction;
  final String currentUserPhone;

  const TransactionCardItem({
    Key? key,
    required this.transaction,
    required this.currentUserPhone,
  }) : super(key: key);

  @override
  State<TransactionCardItem> createState() => _TransactionCardItemState();
}

class _TransactionCardItemState extends State<TransactionCardItem> {
  bool _localeInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    await initializeDateFormatting('fr_FR', null);
    if (mounted) {
      setState(() {
        _localeInitialized = true;
      });
    }
  }

  String _formatDate(DateTime date) {
    if (!_localeInitialized) {
      return ''; // Retourne une chaîne vide si la locale n'est pas encore initialisée
    }
    return DateFormat('dd MMM, HH:mm', 'fr_FR').format(date);
  }

  @override
  Widget build(BuildContext context) {
    bool isOutgoing = widget.transaction.expediteur.telephone == widget.currentUserPhone;
    String description = '';
    String amount = '';

    switch (widget.transaction.type) {
      case 'TRANSFERT':
        if (isOutgoing) {
          description = 'À ${widget.transaction.destinataire.prenom} ${widget.transaction.destinataire.nom}';
          amount = '-${widget.transaction.montantTotal}';
        } else {
          description = 'De ${widget.transaction.expediteur.prenom} ${widget.transaction.expediteur.nom}';
          amount = '+${widget.transaction.montant}';
        }
        break;
      default:
        description = widget.transaction.type;
        amount = widget.transaction.montant.toString();
    }

    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
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
                    _formatDate(widget.transaction.date),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    description,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Frais: ${widget.transaction.frais}F',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${amount}F',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isOutgoing ? Colors.red : Colors.green,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  widget.transaction.status,
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.transaction.status.toLowerCase() == 'active' 
                      ? Colors.green 
                      : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}