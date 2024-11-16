import 'package:flutter/material.dart';
import 'package:moneyflow/utils/constants/colors.dart';
import 'package:moneyflow/utils/constants/dimensions.dart';

class AccountCard extends StatelessWidget {
  final String nom;
  final String prenom;
  final double solde;

  const AccountCard({
    super.key,
    required this.nom,
    required this.prenom,
    required this.solde,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.padding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$nom $prenom',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.padding8),
            Text(
              'Solde: ${solde.toStringAsFixed(2)} F',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}