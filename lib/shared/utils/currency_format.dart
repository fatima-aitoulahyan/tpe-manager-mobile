import 'package:intl/intl.dart';

extension CurrencyFormatter on num {
  String toDH() {
    final format = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'DH',
      decimalDigits: 2,
    );
    return format.format(this);
  }
}