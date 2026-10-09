import 'package:flutter_test/flutter_test.dart';
import 'package:solcafe/features/settings/presentation/providers/currency_provider.dart';

void main() {
  group('CurrencySettings Tests', () {
    test('default constructor provides INR and ₹ fallback', () {
      const settings = CurrencySettings();
      expect(settings.code, equals('INR'));
      expect(settings.symbol, equals('₹'));
    });

    test('parses INR settings correctly from general nested map', () {
      final map = {
        'general': {
          'currency': 'INR',
          'currencySymbol': '₹',
        },
      };
      final settings = CurrencySettings.fromFirestoreMap(map);
      expect(settings.code, equals('INR'));
      expect(settings.symbol, equals('₹'));
      expect(settings.formatPrice(650), equals('₹650'));
      expect(settings.formatPrice(12.5), equals('₹12.50'));
    });

    test('parses USD settings correctly from general nested map', () {
      final map = {
        'general': {
          'currency': 'USD',
          'currencySymbol': '\$',
        },
      };
      final settings = CurrencySettings.fromFirestoreMap(map);
      expect(settings.code, equals('USD'));
      expect(settings.symbol, equals('\$'));
      expect(settings.formatPrice(15), equals('\$15'));
      expect(settings.formatPrice(9.99), equals('\$9.99'));
    });

    test('handles missing or null data safely with INR fallback', () {
      final nullSettings = CurrencySettings.fromFirestoreMap(null);
      expect(nullSettings.code, equals('INR'));
      expect(nullSettings.symbol, equals('₹'));

      final emptySettings = CurrencySettings.fromFirestoreMap({});
      expect(emptySettings.code, equals('INR'));
      expect(emptySettings.symbol, equals('₹'));

      final invalidSettings = CurrencySettings.fromFirestoreMap({
        'general': {'currency': '', 'currencySymbol': ''}
      });
      expect(invalidSettings.code, equals('INR'));
      expect(invalidSettings.symbol, equals('₹'));
    });

    test('parses top-level currency keys as fallback', () {
      final map = {
        'currency': 'EUR',
        'currencySymbol': '€',
      };
      final settings = CurrencySettings.fromFirestoreMap(map);
      expect(settings.code, equals('EUR'));
      expect(settings.symbol, equals('€'));
      expect(settings.formatPrice(100), equals('€100'));
    });
  });
}
