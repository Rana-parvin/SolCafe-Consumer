import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/core/utils/price_parser.dart';

class CurrencySettings {
  final String code;
  final String symbol;

  const CurrencySettings({
    this.code = 'INR',
    this.symbol = '₹',
  });

  factory CurrencySettings.fromFirestoreMap(Map<String, dynamic>? data) {
    if (data == null) {
      return const CurrencySettings(code: 'INR', symbol: '₹');
    }

    String? code;
    String? symbol;

    if (data['general'] is Map<String, dynamic>) {
      final general = Map<String, dynamic>.from(data['general'] as Map);
      code = general['currency']?.toString();
      symbol = general['currencySymbol']?.toString();
    }

    code ??= data['currency']?.toString() ?? data['general.currency']?.toString();
    symbol ??= data['currencySymbol']?.toString() ?? data['general.currencySymbol']?.toString();

    final cleanCode = (code != null && code.trim().isNotEmpty) ? code.trim() : 'INR';
    final cleanSymbol = (symbol != null && symbol.trim().isNotEmpty) ? symbol.trim() : '₹';

    return CurrencySettings(
      code: cleanCode,
      symbol: cleanSymbol,
    );
  }

  String formatPrice(dynamic price) {
    final double numPrice = parsePrice(price);
    final String formattedNum = numPrice.toStringAsFixed(
      numPrice.truncateToDouble() == numPrice ? 0 : 2,
    );
    return '$symbol$formattedNum';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencySettings &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          symbol == other.symbol;

  @override
  int get hashCode => code.hashCode ^ symbol.hashCode;

  @override
  String toString() => 'CurrencySettings(code: $code, symbol: $symbol)';
}

final currencySettingsStreamProvider = StreamProvider<CurrencySettings>((ref) {
  return FirebaseFirestore.instance
      .collection('settings')
      .doc('cafe_config')
      .snapshots()
      .map((snapshot) {
    if (!snapshot.exists || snapshot.data() == null) {
      return const CurrencySettings(code: 'INR', symbol: '₹');
    }
    return CurrencySettings.fromFirestoreMap(snapshot.data());
  }).handleError((_, __) => const CurrencySettings(code: 'INR', symbol: '₹'));
});

final currencySettingsProvider = Provider<CurrencySettings>((ref) {
  final asyncVal = ref.watch(currencySettingsStreamProvider);
  return asyncVal.maybeWhen(
    data: (settings) => settings,
    orElse: () => const CurrencySettings(code: 'INR', symbol: '₹'),
  );
});

final currencySymbolProvider = Provider<String>((ref) {
  return ref.watch(currencySettingsProvider).symbol;
});
