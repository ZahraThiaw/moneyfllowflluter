import 'package:flutter/material.dart';

class AppColors {
  // Couleurs existantes
  static const primaryColor = Color.fromARGB(255, 79, 32, 146);
  static const secondaryColor = Color(0xFF03DAC6);
  static const accentColor = Color(0xFFBB86FC);
  static const backgroundColor = Color(0xFFFFFFFF);
  static const errorColor = Color(0xFFCF6679);

  // Nouvelles couleurs pour le gradient et les éléments de la carte
  static const primaryGradientStart = Color(0xFF6E3ABA);  // Violet foncé pour le début du gradient
  static const primaryGradientEnd = Color(0xFF9B6AE5);    // Violet clair pour la fin du gradient
  
  // Couleurs pour le texte
  static const textLight = Color(0xFFFFFFFF);           // Texte blanc
  static const textDark = Color(0xFF000000);            // Texte noir
  
  // Couleurs d'overlay
  static const overlayLight = Color(0x1AFFFFFF);        // Overlay blanc avec 10% d'opacité
}