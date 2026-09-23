import 'package:firebase_analytics/firebase_analytics.dart';

class CartAnalyticsDataSource {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logAddToCart({
    required String itemid,
    required String name,
    required dynamic price,
    required int quantity,
  }) async {
    final double numericPrice = double.tryParse(price.toString()) ?? 0.0;
    await _analytics.logAddToCart(
      items: [
        AnalyticsEventItem(
          itemId: itemid,
          itemName: name,
          price: numericPrice,
          quantity: quantity,
        ),
      ],
    );
  }
}
