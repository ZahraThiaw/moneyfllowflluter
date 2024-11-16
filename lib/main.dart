// lib/main.dart
import 'package:flutter/material.dart';
import 'package:moneyflow/services/auth_service.dart';
import 'package:moneyflow/services/storage_service.dart';
import 'package:moneyflow/services/transaction_service.dart';
import 'package:provider/provider.dart';
import 'package:moneyflow/providers/auth_provider.dart';
import 'package:moneyflow/routes/routes.dart';
import 'package:moneyflow/utils/themes/app_theme.dart';
import 'core/di/service_locator.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  setupServiceLocator(); // Configure tous les services avec GetIt
  
  // Initialiser StorageService avec Hive
  //await sl<StorageService>().init();
  
  final storageService = StorageService();
  await storageService.init();

  Intl.defaultLocale = 'fr_FR';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authService: sl<AuthService>(),
            transactionService: sl<TransactionService>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return MaterialApp(
          title: 'MoneyFlow',
          theme: AppTheme.lightTheme,
          initialRoute: authProvider.user != null 
            ? AppRoutes.homeRoute 
            : AppRoutes.loginRoute,
          routes: AppRoutes.routes,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
