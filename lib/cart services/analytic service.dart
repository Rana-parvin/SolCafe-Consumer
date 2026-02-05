import 'package:firebase_analytics/firebase_analytics.dart';

class Analyticservice {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  Future<void> logAddToCart({
    required String itemid,
    required String name,
    required double price,
    required int quantity,

  }) async {
    await _analytics.logAddToCart(
      items: [
        AnalyticsEventItem(
          itemId: itemid,
          itemName: name,
          price: price,
          quantity: quantity,
        ),
      ],
    );
  }
}
