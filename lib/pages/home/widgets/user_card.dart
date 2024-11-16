import 'package:flutter/material.dart';
import 'package:moneyflow/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:moneyflow/utils/constants/colors.dart';

class UserCard extends StatelessWidget {
  final VoidCallback onToggleVisibility;

  UserCard({
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.user;
        final qrData = user?.qrcode;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryGradientStart,
                AppColors.primaryGradientEnd,
              ],
            ),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: AppColors.textDark.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Cercles décoratifs en arrière-plan
              Positioned(
                top: -20,
                left: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.overlayLight,
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                right: -20,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.overlayLight,
                  ),
                ),
              ),
              // Contenu
              Column(
                children: [
                  // En-tête avec le titre et le logo
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Centre le titre
                      children: [
                        Text(
                          'MoneyFlow',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8), // Espace entre le titre et le logo
                        Image.asset(
                          'assets/images/logo.png',
                          width: 32,
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                  // QR Code agrandi
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 140, // Augmentation de la taille
                        height: 140, // Augmentation de la taille
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: qrData ?? '',
                          version: QrVersions.auto,
                          backgroundColor: AppColors.backgroundColor,
                          foregroundColor: AppColors.textDark,
                          errorCorrectionLevel: QrErrorCorrectLevel.H, // Meilleure correction d'erreur
                        ),
                      ),
                    ),
                  ),
                  // Texte en bas
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Scanner le QR code',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
