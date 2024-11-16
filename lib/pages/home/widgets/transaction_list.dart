// import 'package:flutter/material.dart';
// import 'package:moneyflow/models/transaction.dart';
// import 'package:moneyflow/providers/user_provider.dart';
// import 'package:moneyflow/utils/constants/colors.dart';
// import 'package:moneyflow/utils/constants/dimensions.dart';
// import 'package:provider/provider.dart';

// class TransactionList extends StatefulWidget {
//   const TransactionList({super.key});

//   @override
//   State<TransactionList> createState() => _TransactionListState();
// }

// class _TransactionListState extends State<TransactionList> {
//   late Future<List<Transaction>> _transactionsFuture;

//   @override 
//   void initState() {
//     super.initState();
//     _transactionsFuture = _fetchTransactions();
//   }

//   Future<List<Transaction>> _fetchTransactions() async {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     return await userProvider.getTransactions();
//   }

//   @override

//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Transaction>>(
//       future: _transactionsFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(
//             child: Text(
//               'Erreur lors du chargement des transactions: ${snapshot.error}',
//               style: const TextStyle(color: AppColors.errorColor),
//             ),
//           );
//         }

//         final transactions = snapshot.data ?? [];

//         return Expanded(
//           child: ListView.builder(
//             itemCount: transactions.length,
//             itemBuilder: (context, index) {
//               final transaction = transactions[index];
//               return Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: AppDimensions.padding8,
//                 ),
//                 child: ListTile(
//                   title: Text(transaction.libelle),
//                   subtitle: Text(
//                     '${transaction.montant.toStringAsFixed(2)} F - ${transaction.date.toString()}',
//                   ),
//                   trailing: Icon(
//                     transaction.montant >= 0
//                         ? Icons.arrow_upward
//                         : Icons.arrow_downward,
//                     color: transaction.montant >= 0
//                         ? AppColors.primaryColor
//                         : AppColors.errorColor,
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }