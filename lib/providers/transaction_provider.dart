import 'package:flutter/material.dart';
import 'package:todofrontendapi/models/transaction.dart';
import 'package:todofrontendapi/providers/auth_provider.dart';
import 'package:todofrontendapi/services/api.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> transactions = [];
  late ApiService apiService;
  final AuthProvider authProvider;

  TransactionProvider(this.authProvider) {
    init();
  }

  // Initialiseer provider
  Future<void> init() async {
    String? token = await authProvider.getToken();

    if (token == null || token.isEmpty) {
      // Als er geen token is, stop en geef een fout
      print('Token not found! Cannot initialize TransactionProvider.');
      return;
    }

    apiService = ApiService(token);
    
    try {
      transactions = await apiService.fetchTransactions();
    } catch (e) {
      print('Failed to fetch transactions: $e');
      transactions = [];
    }

    notifyListeners();
  }

  // Voeg een nieuwe transactie toe
  Future<void> addTransaction(
    String amount,
    String category,
    String description,
    String date,
  ) async {
    try {
      Transaction addedTransaction =
          await apiService.addTransaction(amount, category, description, date);
      transactions.add(addedTransaction);
      notifyListeners();
    } catch (e) {
      print('Failed to add transaction: $e');
    }
  }

  // Update een bestaande transactie
  Future<void> updateTransaction(Transaction transaction) async {
    try {
      Transaction updatedTransaction =
          await apiService.updateTransaction(transaction);
      int index = transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        transactions[index] = updatedTransaction;
        notifyListeners();
      }
    } catch (e) {
      print('Failed to update transaction: $e');
    }
  }

  // Verwijder een transactie
  Future<void> deleteTransaction(Transaction transaction) async {
    try {
      await apiService.deleteTransaction(transaction.id);
      transactions.removeWhere((t) => t.id == transaction.id);
      notifyListeners();
    } catch (e) {
      print('Failed to delete transaction: $e');
    }
  }
}