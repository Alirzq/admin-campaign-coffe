import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return 'Rp ${formatter.format(amount)}';
  }

  static String formatCurrencyFromDouble(double amount) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return 'Rp ${formatter.format(amount.toInt())}';
  }
}
