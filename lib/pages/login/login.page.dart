import 'package:flutter/material.dart';
import 'package:moneyflow/core/http/http_client_interface.dart';
import 'package:moneyflow/routes/routes.dart';
import 'package:moneyflow/services/auth_service.dart';
import 'package:moneyflow/services/transaction_service.dart';
import 'package:moneyflow/utils/constants/colors.dart';
import 'package:moneyflow/widgets/app_logo.dart';
import 'package:moneyflow/providers/auth_provider.dart';
import 'package:moneyflow/core/di/service_locator.dart';
import 'package:provider/provider.dart';
import 'widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(
        authService: sl<AuthService>(),
        transactionService: sl<TransactionService>(),
        httpClient: sl<IHttpClient>(),
      ),
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AppLogo(
                            
                            size: 70,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Connexion',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const LoginForm(),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Pas encore de compte ?',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.signupRoute,
                                  );
                                },
                                child: const Text(
                                  'Créer un compte',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
