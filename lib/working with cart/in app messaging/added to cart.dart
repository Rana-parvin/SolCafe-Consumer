import 'package:firebase_analytics/firebase_analytics.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

Future<void> addedToCart({
  required String itemId,
  required String itemName,
  required double price,
}) async {
  await analytics.logAddToCart(
    items: [
      AnalyticsEventItem(
        itemId: itemId,
        itemName: itemName,
        price: price,
      ),
    ],
  );
}
