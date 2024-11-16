import 'package:flutter/material.dart';
import 'package:moneyflow/widgets/app_logo.dart';
import 'package:moneyflow/providers/auth_provider.dart';
import 'package:moneyflow/routes/routes.dart';
import 'package:moneyflow/utils/constants/colors.dart';
import 'package:moneyflow/services/auth_service.dart';
import 'package:moneyflow/services/transaction_service.dart';
import 'package:moneyflow/core/di/service_locator.dart';
import 'package:provider/provider.dart';
import 'widgets/signup_form.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(
        authService: sl<AuthService>(),
        transactionService: sl<TransactionService>(),
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogo(
                color: AppColors.primaryColor,
                size: 80,
              ),
              const SizedBox(height: 16),
              SignupForm(
                onSignup: (nom, prenom, telephone, email, password) async {
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  bool success = await authProvider.signup(
                    nom: nom,
                    prenom: prenom,
                    telephone: telephone,
                    email: email,
                    password: password,
                  );
                  if (success) {
                    Navigator.pushNamed(context, AppRoutes.homeRoute);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erreur lors de l\'inscription'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.loginRoute);
                },
                child: const Text('Déjà un compte ? Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
