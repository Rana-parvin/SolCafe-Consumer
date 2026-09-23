double parsePrice(dynamic price) {
  if (price is num) return price.toDouble();
  if (price is String) return double.tryParse(price) ?? 0.0;
  return 0.0;
}
