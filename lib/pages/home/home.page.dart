// home_page.dart
import 'package:flutter/material.dart';
import 'package:moneyflow/pages/home/widgets/action_section.dart';
import 'package:moneyflow/pages/home/widgets/transaction_card_item.dart';
import 'package:moneyflow/pages/home/widgets/user_card.dart';
import 'package:moneyflow/utils/constants/colors.dart';
import 'package:moneyflow/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isBalanceVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().fetchTransactions();
    });
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = authProvider.user;
            if (user == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Erreur: utilisateur non trouvé'),
                    ElevatedButton(
                      onPressed: authProvider.refreshData,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            }

            return Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon:
                                const Icon(Icons.settings, color: Colors.white),
                            onPressed: () {
                              // Action de l'icône de paramètres
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // Action notifications
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${user.prenom} ${user.nom}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 150),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 160.0),
                            ActionSection(),
                            const SizedBox(height: 24.0),
                            Expanded(
                              child: authProvider.transactions.isEmpty
                                  ? const Center(
                                      child: Text('Aucune transaction trouvée'),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.all(8.0),
                                      itemCount:
                                          authProvider.transactions.length,
                                      itemBuilder: (context, index) {
                                        final transaction =
                                            authProvider.transactions[index];
                                        return TransactionCardItem(
                                          transaction: transaction,
                                          currentUserPhone: user.telephone,
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Column(
                      children: [
                        const Text(
                          'Solde',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isBalanceVisible
                                  ? '${user.solde.toStringAsFixed(0)} F'
                                  : '••••••••••',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                _isBalanceVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: _toggleBalanceVisibility,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 120,
                  left: 16,
                  right: 16,
                  child: UserCard(
                    onToggleVisibility: _toggleBalanceVisibility,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
